     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Get Account Information')           *
     F*****************************************************************
     F*                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008101 - Stamp Tax Get Account Information                 *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  50    First cycle                                            *
      *  90    General work indicator                                 *
      *                                                               *
      *  U7/U8 Error Occurred                                         *
      *  LR    End program                                            *
      *                                                               *
      *****************************************************************
      *
     F/EJECT
      *
      *  Copyright table
      *
     D/COPY CGCPYSRC,SRERRDLE
      *
      *  end of Copysource for error processing
      *
     D/EJECT
     D CPYR@#          DS
      *
      ** Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
     D W0DATA          DS           256
      *
      ** Calling parameter data structure
      *
     D  I#PT1                  1      1
     D  I#PTY1                 2     36
     D  I#PT2                 37     37
     D  I#PTY2                38     72
     D  I#CCY                 73     75
     D  O#CUST                76     81
     D  O#CYCD                82     84
     D  O#ACCD                85     94
     D  O#ACSN                95     96
     D  O#BRCD                97     99
     D DSMTR           DS
      *
      ** Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MPREF                15     30
     D  #MPART                 1      2P 0
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      *
      ** Define Account Details
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      ** Define BIC Directory
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Define Bank Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Define Customer Details
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** Define Counterparty Nostros
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** Define Nostro Details
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      ** Define rundat data area
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data Structures used by Access Programs
      *
     I/COPY FTCPYSRC,SFTADDRILE
      *
      ** Address data structure
      *
      ** Parameter fields
      *
     D @RTCD           S              7
     D @OPTN           S              7
     D @CUST           S              6
     D @CYCD           S              3
     D @ACCN           S             10
     D @ACSN           S              2
     D @NONB           S              2
     D @BRCD           S              3
     D @CSSN           S             10
     D @PNOI           S              1
     D #MSGID          S              7
     D #MSGF           S             10
     D @RETL           S             10
     D @CNUM           S              6
     D @CUCD           S              3
     D @ACCD           S             10
     D @ACSQ           S              2
     D @BRCA           S              3
      *
      ** Work fields
      *
     D W0RTN           S              7
     D W0MSG           S            256
     D W0TYPE          S              1
     D W0CCY           S              3
     D Q               S              5  0
     D W9BICB          S              3
     D W9RTN           S              7
     D W9BICC          S              8
     D W9CUST          S              1
     D W9CNST          S              1
     D W9BICD          S              1
     D BIS@            S             80
     D WUMRDT          S              7
     D WURDNB          S              5  0
     D WUSUC           S              1
     D WUDFF           S              1
     D WUMBIN          S              1
     D/EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      ** Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0DATA
     C                   PARM                    W0MSG
      *
      ** Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   ENDIF
      *
      **  Set up primary reference, and put into address structure
      *
     C     I#PTY2        IFEQ      *BLANKS
     C                   MOVEL     I#PTY1        ADDRSS
     C                   MOVE      I#PT1         W0TYPE
     C                   ELSE
     C                   MOVEL     I#PTY2        ADDRSS
     C                   MOVE      I#PT2         W0TYPE
     C                   ENDIF
     C                   MOVE      I#CCY         W0CCY
      *
      ** Initialise output fields to blanks
      *
     C                   MOVEL     *BLANKS       O#CUST
     C                   MOVEL     *BLANKS       O#CYCD
     C                   MOVEL     *BLANKS       O#ACCD
     C                   MOVEL     *BLANKS       O#ACSN
     C                   MOVEL     *BLANKS       O#BRCD
     C                   MOVEL     *BLANKS       W0MSG
      *
      ** Execute party type check processing
      *
     C     W0TYPE        CASEQ     'A'           SRADDR                         Address
     C     W0TYPE        CASEQ     'C'           SRCNUM                         Customer nbr
     C     W0TYPE        CASEQ     'F'           SRFNOS                         Full Nostro
     C     W0TYPE        CASEQ     'G'           SRGLAC                         GL Account
     C     W0TYPE        CASEQ     'N'           SRNOSN                         Nostro Nbr
     C     W0TYPE        CASEQ     'P'           SRPTAC                         Partial A/c
     C     W0TYPE        CASEQ     'R'           SRRETL                         Retail A/c
     C     W0TYPE        CASEQ     'S'           SRBIC                          SWIFT BIC id
     C                   CAS                     SRACT
     C                   ENDCS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      ** Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCNUM   : Format Customer                                   *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCNUM        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCNUM'      @STK(Q)
      *
     C                   MOVEL     ADCNUM        O#CUST
      *
      ** Unwind subroutine stack name
      *
     C     EXCNUM        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFNOS   : Format Full Nostro                                *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRFNOS        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFNOS'      @STK(Q)
      *
      ** Get Nostro details
      *
     C                   MOVEL     ADFCCY        @CYCD
     C                   MOVEL     ADFNNB        @NONB
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST
     C                   PARM                    @CYCD
     C                   PARM      *BLANKS       @ACCN
     C                   PARM      *BLANKS       @ACSN
     C                   PARM                    @NONB
     C                   PARM      *BLANKS       @BRCD
     C                   PARM      *BLANKS       @CSSN
     C                   PARM      *BLANKS       @PNOI
     C     SDNOST        PARM      *BLANKS       DSFDY
      *
      ** If nostro is found then output the customer number
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A7CUST        O#CUST
     C                   MOVEL     A7CYCD        O#CYCD
     C                   MOVEL     A7ACCD        O#ACCD
     C                   MOVEL     A7ACSN        O#ACSN
     C                   MOVEL     A7BRCD        O#BRCD
     C                   ELSE
      *
      ** Else, get warning information and perform DB error processing
      *
     C                   MOVEL     *BLANKS       #MSDTA
     C                   MOVEL     ADFNOS        #MSDTA
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'FTM2344 '    #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C*
     C                   MOVEL     #MSTX1        W0MSG
     C*
     C                   MOVEL     'AONOSTR0'    W0FILE                         ***************
     C                   MOVEL     ADFNOS        W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   MOVEL     W0MSG         W0PREF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C     EXFNOS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRGLAC   : Format General Ledger Account                     *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRGLAC        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGLAC'      @STK(Q)
      *
      ** Move the customer number in ADDRSS to the output customer number
      *
     C                   MOVEL     ADGCNM        O#CUST
     C                   MOVEL     ADGCCY        O#CYCD
     C                   MOVEL     ADGACD        O#ACCD
     C                   MOVEL     ADGASQ        O#ACSN
     C                   MOVEL     ADGBRC        O#BRCD
      *
      ** Unwind subroutine stack name
      *
     C     EXGLAC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRNOSN   : Format Nostro Number                              *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRNOSN        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRNOSN'      @STK(Q)
      *
      ** Get Nostro details
      *
     C                   MOVEL     W0CCY         @CYCD
     C                   MOVEL     ADNOSN        @NONB
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST
     C                   PARM                    @CYCD
     C                   PARM      *BLANKS       @ACCN
     C                   PARM      *BLANKS       @ACSN
     C                   PARM                    @NONB
     C                   PARM      *BLANKS       @BRCD
     C                   PARM      *BLANKS       @CSSN
     C                   PARM      *BLANKS       @PNOI
     C     SDNOST        PARM      *BLANKS       DSFDY
      *
      ** If nostro is found then output the customer number
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A7CUST        O#CUST
     C                   MOVEL     A7CYCD        O#CYCD
     C                   MOVEL     A7ACCD        O#ACCD
     C                   MOVEL     A7ACSN        O#ACSN
     C                   MOVEL     A7BRCD        O#BRCD
     C                   ELSE
      *
      ** Else, get warning information and perform DB error processing
      *
     C                   MOVEL     *BLANKS       #MSDTA
     C     W0CCY         CAT(P)    ADNOSN        #MSDTA
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'FTM2344 '    #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        W0MSG
      *
     C                   MOVEL     'AONOSTR0'    W0FILE                         ***************
     C     W0CCY         CAT(P)    ADNOSN        W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   MOVEL     W0MSG         W0PREF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C     EXNOSN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPTAC   : Format Partial Account                            *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRPTAC        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPTAC'      @STK(Q)
      *
      ** Move the customer number in ADDRSS to the output customer number
      *
     C                   MOVEL     ADPCNM        O#CUST
     C                   MOVEL     I#CCY         O#CYCD
     C                   MOVEL     ADPACD        O#ACCD
     C                   MOVEL     ADPASQ        O#ACSN
     C                   MOVEL     ADPBRC        O#BRCD
      *
      ** Unwind subroutine stack name
      *
     C     EXPTAC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRRETL   : Format Retail Account Number                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRRETL        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRETL'      @STK(Q)
      *
      ** Get Account Details
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       @RTCD                          B:Return code
     C                   PARM      '*KEY   '     @OPTN                          I:Option
     C                   PARM      ADACNO        @RETL                          I:Retail key
     C                   PARM      *BLANKS       @CNUM                          I:Key field 1
     C                   PARM      *BLANKS       @CUCD                          I:Key field 2
     C                   PARM      *BLANKS       @ACCD                          I:Key field 3
     C                   PARM      *BLANKS       @ACSQ                          I:Key field 4
     C                   PARM      *BLANKS       @BRCA                          I:Key field 5
     C     ACCNT         PARM                    DSSDY                          O:OUTPUT
      *
      ** If no error, then output the customer number
      *
     C     *IN90         IFEQ      '0'
     C     @RTCD         ANDEQ     *BLANKS
     C                   MOVEL     CNUM          O#CUST
     C                   MOVEL     CCY           O#CYCD
     C                   MOVEL     ACOD          O#ACCD
     C                   MOVEL     ACSQ          O#ACSN
     C                   MOVEL     BRCA          O#BRCD
     C                   ELSE
      *
      ** Else, get warning information and perform DB error processing
      *
     C                   MOVEL     *BLANKS       #MSDTA
     C                   MOVEL     ADCHK1        #MSDTA
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'FTM2346 '    #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        W0MSG
      *
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     ADACNO        W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   MOVEL     W0MSG         W0PREF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C     EXRETL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBIC    : Format BIC Identifier                             *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRBIC         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBIC '      @STK(Q)
      *
      ** If BIC access BIC directory
      *
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     ADCHK1        W9BICC
     C     3             SUBST     ADCHK1:9      W9BICB
     C                   ELSE
     C                   MOVEL     ADCHK2        W9BICC
     C     3             SUBST     ADCHK2:9      W9BICB
     C                   ENDIF
      *
     C                   CALL      'ME1400'                             9090
     C                   PARM      *BLANKS       W9RTN
     C                   PARM                    W9BICC
     C                   PARM                    W9BICB
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST
     C                   PARM      *BLANKS       W9CNST
     C                   PARM      *BLANKS       W9BICD
      *
     C     *IN90         IFEQ      '1'
     C     W9RTN         OREQ      'MIN0244'
     C     W9RTN         OREQ      'MIN0245'
     C     W9RTN         OREQ      'MIN0246'
     C                   MOVEL     'ME1400  '    W0FILE                         ***************
     C                   MOVEL     '*CALL   '    W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If W9CUST =  'Y' then output the customer number
      *
     C     W9CUST        IFEQ      'Y'
     C                   MOVEL     BBCUST        O#CUST
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C     EXBIC         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRADDR   : Format Address                                    *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRADDR        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRADDR'      @STK(Q)
      *
      ** Unwind subroutine stack name
      *
     C     EXADDR        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *
      *  File and Program Error Processing
      *
     C/COPY CGCPYSRC,SRERRCLE
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACT    : Undefined action - error                          *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRACT         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACT '      @STK(Q)
      *
      ** Database error undefined action
      *
     C                   MOVEL     '*TYPE   '    W0FILE                         ***************
     C                   MOVEL     W0TYPE        W0KEY                          * DB ERROR 15 *
     C                   Z-ADD     15            W0ERNB                         ***************
     C                   MOVEL     'MEM5006'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
      *
      ** Unwind subroutine stack name
      *
     C     EXACT         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      ** Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      ** Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      ** Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT                         Midas Run date
     C                   MOVE      AGRDNB        WURDNB                         Run day number
     C                   MOVE      AGSUC         WUSUC                          Set up complete
     C                   MOVE      AGDFF         WUDFF                          Date Format
     C                   MOVE      AGMBIN        WUMBIN                         Multi Branched
      *
      ** Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      *BLANKS       DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     @RTCD         OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     01            W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
