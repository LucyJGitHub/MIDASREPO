     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Posting Summary')                   *
     F*****************************************************************
     F*                                                               *
     F*  Midas - General Ledger                                       *
     F*                                                               *
     F*  GL008111 - Posting Summary Processing                        *
     F*                                                               *
     F*  (c) Finastra International Limited 2010                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR821972           Date 07Sep11               *
      *                 CER049  *CREATE    Date 06Dec10               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
/*    *  AR821972 - Stamp tax on debit interest did not generate      *
/*    *             amount in GLVCLSIN (Recompile)                    *
     F*  CER049 - Stamp Tax                                           *
     F*                                                               *
     F*****************************************************************
     FGLVCPSPD  O    E             DISK
     FGLPSUMPD  IP   E             DISK
     F                                     RENAME(APOSTPDF:@PSUMPPF)
     FGL008111AUO    E             PRINTER INFDS(SPOOLA)
     FGL008111P1O    E             PRINTER OFLIND(*IN11)
     F                                     INFDS(SPOOL1)
     F*****************************************************************
     F*                                                               *
     F*   F U N C T I O N   O F   I N D I C A T O R S                 *
     F*                                                               *
     F*   11   Detail line overflow indicator                         *
     F*   L1   DRCR level break                                       *
     F*   L2   ACSQ level break                                       *
     F*   L3   ACOD level break                                       *
     F*   L4   CCY level break                                        *
     F*   L5   CNUM level break                                       *
     F*   L6   BRCA level break                                       *
     F*   U7   Database Errors                                        *
     F*   U8   Database Errors                                        *
     F*                                                               *
     F*****************************************************************
     D RRPNAR          S             30    DIM(1) CTDATA PERRCD(1)
     D**  Array for SR. ZSEDIT
     D ZS2             S              1    DIM(21)
     D** Array for Copyright Insertion
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D**  DS for ZSEDIT subroutine
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D** Module Details Accessed via access program
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D** SAR File details accessed via access program AOSARDR0
     D*
     D CGPNAR        E DS                  EXTNAME(CGPNARPD)
     D** UDC Multi-Language Narrative Data Structure
     D*
     D ##PRM1          DS
      ** Data Structure for Customer and Branch
      *
     D  A#CUST                 1      6
     D  A#BRCA                 7      9
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer details
      *
     D SPOOL1          DS
      **  DS FOR P1 SPOOL FILE NAME
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLA          DS
      **  DS FOR AU SPOOL FILE NAME
     D  SFILEA                83     92
     D  SFNUMA               123    124B 0
     D  OFLLNA               188    189B 0
     D  PRTLNA               367    368B 0
      *
     D LDA             DS           256
     D**  Local data area for data base errors.
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** First DS for access programs
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Parameter fields
      *
     D @RTCD           S              7
     D @OPTN           S              7
     D SEQNO           S              5
     D ENTY            S              3
     D ZSERR           S              1
     D @SARD           S              6
     D @KEY            S              3
     D P0MODE          S              1
     D ##RTN           S              7
     D ##OPT           S              7
     D ##KEY           S             10
     D ##STS           S              7
      *
      ** Work fields
      *
     D MKI@            S             80
     D ##FRST          S              1
     D ZSNUM           S              6  0
     D REPNAR          S              1
     D PSTAN           S             13  0
     D PSTAS           S             13  0
     D TOTAC           S             13  0
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
     D Z1              S              2  0
     D Z2              S              2  0
     D ZINTS           S              2  0
     D ZCNT            S              1  0
     D CNT3            S              1  0
     D ##MGID          S              7
     D ##NARR          S             50
      *
     I@PSUMPPF
     I                                          BRCA          L6
     I                                          CNUM          L5
     I                                          CCY           L4
     I                                          ACOD          L3
     I                                          ACSQ          L2
     I                                          DRCR          L1
     C*
     I**  External DS for Currency Details
     C*
     C                   MOVEA     CPY@          MKI@
     C*
     C*****************************************************************
     C*   M A I N    P R O G R A M                                    *
     C*****************************************************************
     C*
     C     ##FRST        IFEQ      *BLANKS
     C                   MOVEL     'Y'           ##FRST
     C                   ADD       1             NORE1
     C                   MOVEL     'GL008111'    DBPGM
     C*
     C     *DTAARA       DEFINE                  LDA
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   Z-ADD     001           DBASE
     C                   EXSR      #DBER
     C                   END
     C                   WRITE     HEADP1
      *
      ** Ensure the P1 spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM1        ZSNUM
      *
      ** Call ZSFILE for GL008111P1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
      ** If error in ZSFILE, exit via #DBER
      *
     C     ZSERR         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   EXSR      #DBER
     C                   ENDIF
      *
     C                   WRITE     HEADAU
      *
      ** Ensure the AU spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUMA        ZSNUM
      *
      ** Call ZSFILE for GL008111AU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILEA
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
      ** If error in ZSFILE, exit via #DBER
      *
     C     ZSERR         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   EXSR      #DBER
     C                   ENDIF
      *
      ** Call module prog. for module details.
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      #DBER
     C                   ELSE
      *
      ** Call SAR prog. for switchable feature
      *
     C                   MOVE      'N'           REPNAR
     C     BGN1ST        IFEQ      'Y'
     C*
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'REPNAR'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   EXSR      #DBER
     C                   ENDIF
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           REPNAR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   GOTO      DETAIL
     C                   END
     C*
     C     *IN11         IFEQ      '1'
     C     *INL3         OREQ      '1'
     C                   WRITE     HEADP1
     C                   MOVE      '0'           *IN11
     C                   END
     C*
     C     DETAIL        TAG
     C                   ADD       PSTA          PSTAS
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CCY           @KEY
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     @KEY          DBKEY
     C                   Z-ADD     004           DBASE
     C                   EXSR      #DBER
     C                   END
     C     DRCR          IFEQ      0
     C                   ADD       PSTA          TOTAC
     C                   ELSE
     C                   SUB       PSTA          TOTAC
     C                   END
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      PSTA          PSTAN
     C                   MOVE      PSTAN         ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PSTAR
     C                   WRITE     DETLP1
      *
      ** ZEROISE/BLANK OUT 'ASSOCIATED CUSTOMER', 'DEAL LOAN REF' AND
      ** 'FOR ACCOUNT OF' FIELDS AS THESE ARE IRRELEVANT.
      *
     C                   MOVE      *ZEROS        ASOC
     C                   MOVE      *BLANKS       DLREF
     C                   MOVE      *BLANKS       FACO
      *
     CL1                 Z-ADD     PSTAS         PSTA
     CL1                 MOVEA     RRPNAR        PNAR
      *
      ** Get the posting narrative values:
      *
     CL1                 EXSR      SRPNAR
      *
      ** If Primary file empty, do not output record
      *
     CL1   NORE1         IFEQ      0
     CL1                 ELSE
     CL1                 WRITE     APOSTPDF
     CL1                 ADD       1             NORE1
     CL1                 END
     CL1                 Z-ADD     0             PSTAS
     CL2   TOTAC         IFLT      0
     CL2                 Z-SUB     TOTAC         TOTAC
     CL2                 MOVE      'CR'          SIGN
     CL2                 ELSE
     CL2   TOTAC         IFEQ      0
     CL2                 MOVE      '  '          SIGN
     CL2                 ELSE
     CL2                 MOVE      'DR'          SIGN
     CL2                 END
     CL2                 END
     CL2                 MOVE      TOTAC         ZFLD15
     CL2                 EXSR      ZSEDIT
     CL2                 MOVE      ZOUT21        TOTAR
     CL2                 WRITE     TOTAL
     CL2                 Z-ADD     0             TOTAC
     CLRNU7
     CANNU8              WRITE     TRAILP1
     CLRNU7
     CANNU8              WRITE     TOTREC
     C*****************************************************************
     C*                                                               *
     C* #DBER    -   Data Base Error Handling.                        *
     C*                                                               *
     C* CALLS                                                         *
     C*                                                               *
     C* CALLED BY -  #A     : Initialization processing.              *
     C*                                                               *
     C*****************************************************************
     C     #DBER         BEGSR
     C*
     C                   SETON                                        U7U8LR
     C                   WRITE     ERRAU
     C                   WRITE     ERRAP
     C                   OUT       LDA
     C                   RETURN
     C*
     C     #DBER9        ENDSR
      /EJECT
     C********************************************************************
     CSR   ZSEDIT        BEGSR
     C*
     C** Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15
     C                   Z-ADD     ZDECS         ZDECS
     C                   MOVE      ZECODE        ZECODE
     C                   MOVE      *BLANKS       ZOUT21
      *
      ** SET UP WORK FIELDS
      *
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
      *
     C                   Z-ADD     15            Z1
     C                   Z-ADD     20            Z2
      *
     C     15            SUB       ZDECS         ZINTS
      *
      ** Check if numeric field is negative
      *
     C     ZFLD15        IFLT      *ZEROS
     C                   MOVE      '-'           ZS2(21)
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
      *
     C                   Z-ADD     ZFLD15        WORK15
      *
      ** CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
      *
     C     ZDECS         CABEQ     0             ZS10
      *
      ** SET UP DECIMALS
      *
     C                   Z-ADD     *ZEROS        ZCNT
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
      *
      ** PUT IN DECIMAL PLACE
      *
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
      *
     C     ZS10          TAG
      *
      ** SET UP INTEGERS
      *
     C                   Z-ADD     *ZEROS        CNT3
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
      *
      ** If edit code is 'J', insert a ',' before each group of three
      ** digits - not if beginning of array reached.
      *
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
     C*
     C                   END
      *
      ** PUT IN LEADING BLANKS
      *
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     22            ZS20
     C                   END
      *
      ** IF NO INTEGERS PUT IN LEADING ZERO
      *
     C     ZS20          TAG
      *
     C     Z2            IFEQ      22
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
      *
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
      *
      ** SET UP OUTPUT FIELD
      *
     C                   MOVEA     ZS2           ZOUT21
     C*
     CSR                 ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRPNAR determines the required narratives.         **
     C********************************************************************
     C     SRPNAR        BEGSR
      *
      ** Define the data structure parameter:
      *
     C     *LIKE         DEFINE    CGPNAR        ##PNAR
      *
      ** If the facility is switched off or unavailable,
      ** or UDC is not installed, exit this subroutine:
      *
     C     REPNAR        IFNE      'Y'
     C                   GOTO      EXPNAR
     C                   ENDIF
      *
      ** Determine the customer's name:
      *
     C                   MOVEL(P)  CNUM          ##KEY
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM                    ##RTN
     C                   PARM      '*KEY   '     ##OPT
     C                   PARM                    ##KEY
     C                   PARM                    ##STS
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     ##RTN         IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   MOVEL     ##KEY         DBKEY
     C                   EXSR      #DBER
     C                   ENDIF
     C*...................................................................
     C/EJECT
      *...................................................................
      ** Determine the value for the posting narrative using AOPNARR0:
      *
     C                   CLEAR                   CGPNAR
     C                   CLEAR                   ##PRM1
     C*
     C                   MOVE      'RE'          MNMODI
     C                   MOVE      CNUM          MNCUST
     C                   MOVE      CCY           MNCYCD
     C                   MOVE      ACOD          MNACCD
     C                   MOVE      ACSQ          MNACSQ
     C                   MOVE      BRCA          MNBRCA
     C                   MOVE      BOKC          MNBOKC
     C                   MOVE      BBCRNM        MNCRNM
     C                   MOVE      PNAR          MNNARR
     C                   MOVE      ASOC          MNASOC
     C                   MOVE      ACNO          MNRACN
     C*
     C                   CALL      'AOPNARR0'
     C                   PARM                    ##RTN
     C                   PARM      'GB00001'     ##MGID
     C                   PARM                    ##PRM1
     C     CGPNAR        PARM      CGPNAR        ##PNAR
     C                   PARM                    ##NARR
     C*
     C     ##RTN         IFNE      *BLANKS
     C                   MOVEL     'CGPNARPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   MOVEL     MNCUST        DBKEY
     C                   EXSR      #DBER
     C                   ENDIF
     C*
     C                   MOVEL(P)  ##NARR        PNAR
     C*
     C     EXPNAR        TAG
     C*
     C                   ENDSR
     C********************************************************************
** RRPNAR
Stamp Tax Posting Summary
** CPY@   **      OBJECT COPYRIGHT
(C) Copyright Finastra International Limited 2010
