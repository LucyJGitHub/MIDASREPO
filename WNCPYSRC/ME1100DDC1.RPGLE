      *****************************************************************
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 ESL038   *CREATE   Date 26Nov2004             *
      *---------------------------------------------------------------*
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  ESL038 - EBA Mapping                                         *
      *****************************************************************
      *
      ** Access SAR details file to determine if ESL038 is switched ON
      *
     C     ESL038        IFEQ      *BLANKS
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*VERIFY'     P@OPTN            7
     C                   PARM      'ESL038'      P@SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     'Y'           ESL038            1
     C                   ELSE
     C                   MOVEL     'Y'           ESL038            1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESL038        IFEQ      'Y'
      *
      * Set key block 3 is sequence 0
      *
     C                   Z-ADD     PHMSGR        KFMSGR                         Msg Ref.
     C                   Z-ADD     0             KFPART                         Part No.
     C                   MOVEL(P)  '103:'        KFTAG                          Tag No.
     C                   Z-ADD     0             KFSEQ                          Sequence No.
     C                   MOVEL     *BLANKS       KFMSEQ                         Sequence No.
      *
      *  Position and read record
      *
     C                   MOVE      '0'           *IN11                                        CRT002
     C                   MOVE      '0'           *IN12                                        CRT002
      *
     C     KYINDT        SETLL     MEINDTS2
     C                   READ      MEINDTS2                               60
      *
     C     DTMTG         IFEQ      '103:'
     C                   MOVEL     *BLANKS       WKDATA
     C   11              MOVEL     DTMFLD        WKDATA
     C   12              MOVEL     DSMF35        WKDATA
     C     WKDATA        IFNE      *BLANKS
      * Define key
     C     KYLCSD        KLIST
     C                   KFLD                    LCCYCD
     C                   KFLD                    LCYCPY
      * Set Key
     C                   MOVEL     MPCYCD        LCCYCD
     C                   MOVEL     WKDATA        LCYCPY
      * Set Key
     C     KYLCSD        CHAIN     SDLCSDD0                           90
      * If found map account
     C     *IN90         IFEQ      *OFF
     C                   SELECT
      * Cover then fill in receiver's correspondent
     C     P54           WHENEQ    *BLANKS
     C     P53           ANDNE     *BLANKS
     C                   MOVEL     P54           DSOUT
     C                   MOVEL     ':54D:'       OTTAG
     C                   MOVE      LCSETA        ##008A            8
     C                   MOVEL     *BLANKS       ##035A           35
      * If not retail them construct nostro
     C     ##008A        IFEQ      *BLANKS
     C                   MOVEL     LCCYCD        A7CYCD
     C                   MOVEL     LCSETA        A7NONB
     C     KNOST         CHAIN     @A7REB9                            90
      * If found set up
     C     *IN90         IFEQ      *OFF
     C                   MOVEL(P)  *BLANKS       OTCODE
     C     OTCODE        CAT       A7CUST:0      OTCODE
     C     OTCODE        CAT       A7CYCD:0      OTCODE
     C     OTCODE        CAT       A7ACCD:0      OTCODE
     C                   MOVEL(P)  A7ACSN        ##002A            2
     C     OTCODE        CAT       ##002A:0      OTCODE
     C     OTCODE        CAT       A7BRCD:0      OTCODE
     C                   ENDIF
      * Set screen field
     C     LCCYCD        CAT(P)    LCSETA:0      ##035A
     C                   MOVEL     ##035A        OUT(1)
      *
     C                   ELSE
     C                   MOVEL     LCSETA        ##035A
     C                   MOVEL     ##035A        OUT(1)
      * Account number
     C                   MOVEL     LCSETA        ACNO
     C     KACNUM        CHAIN     ACCNTABF                           90
      * If found set up
     C     *IN90         IFEQ      *OFF
     C                   MOVEL(P)  *BLANKS       OTCODE
     C                   MOVEL(P)  CNUM          ##006A            6
     C     OTCODE        CAT       ##006A:0      OTCODE
     C     OTCODE        CAT       CCY:0         OTCODE
     C                   MOVEL(P)  ACOD          ##004A            4
     C     OTCODE        CAT       ##004A:0      OTCODE
     C                   MOVEL(P)  ACSQ          ##002A            2
     C     OTCODE        CAT       ##002A:0      OTCODE
     C     OTCODE        CAT       BRCA:0        OTCODE
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     DSOUT         P54
      * No cover information
     C     P54           WHENEQ    *BLANKS
     C     P53           ANDEQ     *BLANKS
     C                   MOVEL     P53           DSOUT
     C                   MOVEL     ':53D:'       OTTAG
     C                   MOVE      LCSETA        ##008A            8
     C                   MOVEL     *BLANKS       ##035A           35
      * If not retail them construct nostro
     C     ##008A        IFEQ      *BLANKS
      * Look up details
     C     KNOST         KLIST
     C                   KFLD                    A7CYCD
     C                   KFLD                    A7NONB
     C                   MOVEL     LCCYCD        A7CYCD
     C                   MOVEL     LCSETA        A7NONB
     C     KNOST         CHAIN     @A7REB9                            90
      * If found set up
     C     *IN90         IFEQ      *OFF
     C                   MOVEL(P)  *BLANKS       OTCODE
     C     OTCODE        CAT       A7CUST:0      OTCODE
     C     OTCODE        CAT       A7CYCD:0      OTCODE
     C     OTCODE        CAT       A7ACCD:0      OTCODE
     C                   MOVEL(P)  A7ACSN        ##002A            2
     C     OTCODE        CAT       ##002A:0      OTCODE
     C     OTCODE        CAT       A7BRCD:0      OTCODE
     C                   ENDIF
      * Set screen field
     C     LCCYCD        CAT(P)    LCSETA:0      ##035A
     C                   MOVEL     ##035A        OUT(1)
      *
     C                   ELSE
      * Set up data
     C                   MOVEL     LCSETA        ##035A
     C                   MOVEL     ##035A        OUT(1)
      * Look up details
     C     KACNUM        KLIST
     C                   KFLD                    ACNO
      * Account number
     C                   MOVEL     LCSETA        ACNO
     C     KACNUM        CHAIN     ACCNTABF                           90
      * If found set up
     C     *IN90         IFEQ      *OFF
     C                   MOVEL(P)  *BLANKS       OTCODE
     C                   MOVEL(P)  CNUM          ##006A            6
     C     OTCODE        CAT       ##006A:0      OTCODE
     C     OTCODE        CAT       CCY:0         OTCODE
     C                   MOVEL(P)  ACOD          ##004A            4
     C     OTCODE        CAT       ##004A:0      OTCODE
     C                   MOVEL(P)  ACSQ          ##002A            2
     C     OTCODE        CAT       ##002A:0      OTCODE
     C     OTCODE        CAT       BRCA:0        OTCODE
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     DSOUT         P53
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *****************************************************************
      * End of ME1100DDC1                                             *
      *****************************************************************
