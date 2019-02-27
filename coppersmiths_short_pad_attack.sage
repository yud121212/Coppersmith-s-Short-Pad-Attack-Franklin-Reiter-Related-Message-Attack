# source code http://inaz2.hatenablog.com/entry/2016/01/20/022936


def short_pad_attack(c1, c2, e, n):

    PRxy.<x,y> = PolynomialRing(Zmod(n))

    PRx.<xn> = PolynomialRing(Zmod(n))

    PRZZ.<xz,yz> = PolynomialRing(Zmod(n))


    g1 = x^e - c1

    g2 = (x+y)^e - c2


    q1 = g1.change_ring(PRZZ)

    q2 = g2.change_ring(PRZZ)


    h = q2.resultant(q1)

    h = h.univariate_polynomial()

    h = h.change_ring(PRx).subs(y=xn)

    h = h.monic()


    kbits = n.nbits()//(2*e*e)

    diff = h.small_roots(X=2^kbits, beta=0.5)[0]  # find root < 2^kbits with factor >= n^0.5


    return diff


def related_message_attack(c1, c2, diff, e, n):

    PRx.<x> = PolynomialRing(Zmod(n))

    g1 = x^e - c1

    g2 = (x+diff)^e - c2


    def gcd(g1, g2):

        while g2:

            g1, g2 = g2, g1 % g2

        return g1.monic()


    return -gcd(g1, g2)[0]



if __name__ == '__main__':

    n = 103812409689464886276475047044770609297885893720146571798654593885477457188425375786047017735691464865799751262776976174291152757506033948402223696021505470811665108707476725788296289255777914656800454451779117367605227364391483323666809650532860469176398816220707851639905500304208833022438234033264200398959

    e = 3


    C1 = 9317106922634505445328279149755295612464875825943780841886193649700131610057100771444165757592479299555845021862440454968502065319770337331674061960123779876709748994547507057835826773522733671492329400557540100987018908395372213360970889608191940631081957498661950679566048064234326337242245437800870328713

    C2 = 9314352234311777268152500810432217195086739647228997430466360767070638972017377674642639833356580951663634114522574738957708645348438979256455824440476178459296267056062724307782801856615506577790281367843133061096735566462588088807072141910079117362448136849082448630141871675817981866725491776400151339928

    C3 = 102298788718908831383454512674839558060033746080468660252243145800572734468521296602058538109452538907204027081338987796558296639830757629468491322438048912956916198524821066676689795698612028521062296901313097979278633376983280108123961097977187251599033620058543603046291262367128490175209233898073639549204


    nbits = n.nbits()

    kbits = nbits//(2*e*e)

    print "padding lenght %d bytes " % (kbits/8)

    print "upper %d bits (of %d bits) is same" % (nbits-kbits, nbits)


 

    diff = short_pad_attack(C1, C2, e, n)

   #print "difference of two messages C1 and C2 is %d" % diff

    m = related_message_attack(C1, C2, diff, e, n)

    M1 = hex(int(m))[2:-1].decode('hex')

    M2 = hex(int(m+diff))[2:-1].decode('hex')

    print "Message of C1 is ", M1

    print "Message of C2 is ", M2



    diff = short_pad_attack(C1, C3, e, n)

    #print "difference of two messages C1 and C3 is ", diff

    M3 = hex(int(m+diff))[2:-1].decode('hex')

    print "Message of C3 is ", M3


    print "Flag: ", M1[-6:] + M2[-6:] +M3[-6:]
