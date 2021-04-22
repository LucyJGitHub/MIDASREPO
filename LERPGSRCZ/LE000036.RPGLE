     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000036 - Total Repayments                                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE154  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement                 *
      *                                                               *
      *****************************************************************

      * Midas Loans File
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
      * Midas Loan Amendments File
     FLELOAML3  IF   E           K DISK    INFSR(*PSSR)

     ******************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Feature Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** Data Structure
     D ZOUT22          DS            22
     D ZOUT21                  1     21
     D ZOUT20                  1     20
     D ZNEG                   21     21

      ** Data structure to define variables used in holiday sub-routines
     D  ZIND           S              1
     D  ZDAYNO         S              5  0
     D  ZCCY           S              3
     D  ZLOC           S              3

     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================

     C                   MOVE      LNRFA         K@LNRF
     C                   MOVE      'A'           K@RCDT
     C     KEYLnrf       CHAIN     CLOAN
     C                   If        %Found(CLOAN)
      *
      ** Access the decimal places for Loan currency:
      *
     C                   MOVEL     CCY           @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     CPAM          ZIAMT
     C                   Z-ADD     SLID          ZIBEG
     C                   Z-ADD     INTR          ZIRATE
     C                   Z-ADD     ICBS          ZICALC
     C                   Z-ADD     A6NBDP        ZDECS             1 0
     C                   Z-ADD     0             TOTREP           13 0
      *
      ** Access all Loan Amendments for the Loan
      *
     C     Lnrf          SETLL     LOAMSDKF
     C     Lnrf          READE     LOAMSDKF                               89
     C                   DOW       *IN89 = '0'
     C     Amtp          IFEQ      'PI'
     C                   ADD       PRAM          ZIAMT
     C                   ENDIF
      *
     C     Amtp          IFEQ      'RE'
      *
     C     Rept          IFNE      3
     C                   ADD       PRAM          TOTREP
     C                   SUB       PRAM          ZIAMT
     C                   ELSE
     C                   Z-ADD     VDAT          ZIEND
      *
     C                   If        CLE028 = 'Y' and PTYP = 80
     C                   EXSR      SROSIN
     C                   else
     C                   EXSR      GLINTC
     C                   Endif
      *
     C                   Z-ADD     ZIEND         ZIBEG
     C                   Z-ADD     ZINTR         INTPER           30 9
     C                   ADD       PRAM          TOTREP
     C                   SUB       INTPER        TOTREP
     C                   SUB       PRAM          ZIAMT
     C                   ADD       INTPER        ZIAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     Lnrf          READE     LOAMSDKF                               89
     C                   ENDDO

     C                   Z-ADD     TotRep        ZFLD15           15 0
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED

     C                   If        ZNEG = '-'
     C                   MOVE      ZOUT21        WrkTotalRepay
     C                   else
     C                   MOVE      ZOUT20        WrkTotalRepay
     C                   Endif
      *
     C                   else
     C                   MOVE      *BLANKS       WrkTotalRepay
     C                   Endif
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      *                                                               *
      *  SROSIN - Calculate Outstanding Interest via Rule of 78       *
      *                                                               *
      *****************************************************************

     C     SROSIN        BEGSR

     C                   Z-ADD     VDAT          W78VDT
     C                   Z-ADD     MDAT          W78MDT
     C                   Z-ADD     FLTI          W78FLT
     C                   MOVE      RFRQ          W78RPF
     C                   Z-ADD     FRPD          W78FRD
     C                   Z-ADD     RDYN          W78RPM
     C                   MOVE      CCY           W78CCY
     C                   MOVE      *BLANKS       W78LCN
     C                   Z-ADD     VDAT          W78BEG
     C                   Z-ADD     ZIEND         W78END
     C                   MOVE      'A'           W78ROA
      *
     C                   EXSR      RULE78
     C                   Z-ADD     W78INT        ZINTR

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  ZFRPED                                                       *
      *                                                               *
      *****************************************************************

     C     ZFRPED        BEGSR

     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE            1
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  GLINTC - Calculate interest on period                        *
      *                                                               *
      *****************************************************************

     C     GLINTC        BEGSR

     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG             5 0       STARTING DATE
     C                   PARM                    ZIEND             5 0       FINISHING DATE
     C                   PARM                    ZICALC            1 0       CALC. BASIS
     C                   PARM                    ZIAMT            15 0       PRINCIPAL
     C                   PARM                    ZIRATE           11 7       RATE OF INTRST
     C                   PARM                    ZINTR            30 9       INTEREST

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  RULE78 - Calculate Outstanding interest for a given period   *
      *           based on Rule of 78                                 *
      *****************************************************************

     C     RULE78        BEGSR
      *
      ** Define input and output fields
      *
     C                   Z-ADD     W78VDT        W78VDT            5 0
     C                   Z-ADD     W78MDT        W78MDT            5 0
     C                   Z-ADD     W78FLT        W78FLT           15 0
     C                   MOVE      W78RPF        W78RPF            1
     C                   Z-ADD     W78FRD        W78FRD            5 0
     C                   Z-ADD     W78RPM        W78RPM            2 0
     C                   MOVE      W78CCY        W78CCY            3
     C                   MOVE      W78LCN        W78LCN            3
     C                   Z-ADD     W78BEG        W78BEG            5 0
     C                   Z-ADD     W78END        W78END            5 0
     C                   MOVE      W78ROA        W78ROA            1
     C                   Z-ADD     *ZERO         W78INT           30 9
     C                   Z-ADD     *ZERO         W78SUM            6 0
     C                   Z-ADD     *ZERO         W78NPY            5 0
     C                   Z-ADD     *ZERO         W78NTH            3 0
     C                   Z-ADD     *ZERO         W78PRD            3 0
      *
      ** Save fields, may be used in other programs
      *
     C                   Z-ADD     ZDAYNO        WZDAYN            6 0
     C                   MOVE      ZFREQ         WZFREQ            1
     C                   Z-ADD     ZMDAY         WZMDAY            2 0
     C                   MOVE      ZCCY          WZCCY             3
     C                   MOVE      ZLOC          WZLOC             3
      *
      ** Compute for the total number of payments during the life of
      ** the loan, depending on the repayment frequency
      *
     C     W78RPF        IFEQ      *BLANKS
     C                   GOTO      ERUL78
     C                   ENDIF
      *
     C                   Z-ADD     1             W78NPY
     C                   Z-ADD     W78FRD        ZDAYNO
     C                   MOVE      W78RPF        ZFREQ
     C                   Z-ADD     W78RPM        ZMDAY
     C                   MOVE      W78CCY        ZCCY
     C                   MOVE      W78LCN        ZLOC
     C                   EXSR      ZFREQB
     C     ZDAYNO        DOWLT     W78MDT
     C                   ADD       1             W78NPY
     C                   EXSR      ZFREQB
     C                   ENDDO
      *
      ** Add 1 to total number of payments to include repayment on
      ** maturity date
      *
     C                   ADD       1             W78NPY
      *
      ** Compute for the sum of digits
      *
     C     W78NPY        ADD       1             WKSUM             8 2
     C                   DIV       2             WKSUM
     C     WKSUM         MULT      W78NPY        W78SUM
      *
      ** If first repayment date is a holiday, move to next working day
      *
     C                   Z-ADD     W78FRD        ZDAYNO
     C                   MOVE      W78CCY        ZCCY
     C                   MOVE      W78LCN        ZLOC
     C                   MOVE      *BLANKS       ZIND
     C     ZIND          DOUNE     'H'
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C                   ADD       1             ZDAYNO
     C                   ENDIF
     C                   ENDDO
      *
      ** Compute for the Nth payment for interest for a given period
      *
     C     W78ROA        IFEQ      'A'
     C     W78VDT        IFEQ      W78BEG
     C                   Z-ADD     1             W78NTH
     C                   ELSE
     C                   Z-ADD     2             W78NTH
     C                   ENDIF
     C                   ELSE
     C     W78BEG        IFLT      ZDAYNO
     C     W78BEG        IFEQ      W78END
     C                   Z-ADD     ZDAYNO        W78END
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        W78BEG
     C                   ENDIF
     C                   Z-ADD     1             W78NTH
     C                   ENDIF
      *
     C                   MOVE      W78RPF        ZFREQ
     C                   Z-ADD     W78RPM        ZMDAY
     C                   MOVE      W78CCY        ZCCY
     C                   MOVE      W78LCN        ZLOC
     C     ZDAYNO        DOWLT     W78BEG
     C                   EXSR      ZFREQB
     C                   ADD       1             W78NTH
      *
      ** If next  repayment date is a holiday, move to next working day
      *
     C     ZIND          DOUNE     'H'
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C                   ADD       1             ZDAYNO
     C                   ENDIF
     C                   ENDDO
     C                   ENDDO
      *
      ** If end date < start date, OR amortisation date same or after
      ** maturity date, OR repayment date is after maturity date,
      ** OR repayment date earlier than the first repayment date
      ** - zeroise the interest amount
      *
     C     W78END        IFLT      W78BEG
     C     W78BEG        ORGE      W78MDT
     C     W78ROA        ANDEQ     'A'
     C     W78BEG        ORLT      W78VDT
     C     W78ROA        ANDEQ     'A'
     C     W78BEG        ORGT      W78MDT
     C     W78ROA        ANDEQ     'R'
     C     W78BEG        ORLT      W78FRD
     C     W78END        ANDLT     W78FRD
     C     W78ROA        ANDEQ     'R'
     C                   Z-ADD     *ZERO         W78INT
     C                   GOTO      ERUL78
     C                   ENDIF
      *
     C                   Z-ADD     W78NTH        WKSAV             3 0
      *
      ** Compute for outstanding interest for the period
      ** until given end date or until
      *
     C     ZDAYNO        DOUGT     W78END
     C     W78NTH        ORGT      W78NPY
     C     W78NPY        SUB       W78NTH        WINTPD           30 9
     C                   ADD       1             WINTPD
     C                   MULT      W78FLT        WINTPD
     C                   DIV       W78SUM        WINTPD
     C                   ADD       WINTPD        W78INT
      *
      ** Do not process frequency date calculation on first payment
      ** date, i.e., beginning date is less than FRPD
      *
     C     W78NTH        IFNE      1
     C     W78ROA        ANDEQ     'A'
     C     W78ROA        OREQ      'R'
     C                   EXSR      ZFREQB
      *
      ** If next  repayment date is a holiday, move to next working day
      *
     C     ZIND          DOUNE     'H'
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C                   ADD       1             ZDAYNO
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ADD       1             W78NTH
     C                   ADD       1             W78PRD
     C                   ENDDO
     C                   SUB       1             W78PRD
     C                   Z-ADD     WKSAV         W78NTH            3 0
      *
      ** Restore fields, may be used in other programs
      *
     C     ERUL78        TAG
     C                   Z-ADD     WZDAYN        ZDAYNO
     C                   MOVE      WZFREQ        ZFREQ
     C                   Z-ADD     WZMDAY        ZMDAY
     C                   MOVE      WZCCY         ZCCY
     C                   MOVE      WZLOC         ZLOC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFREQB - Calc day num of next pymnt frq from curr dayno       *
      *                                                               *
      *****************************************************************
     C     ZFREQB        BEGSR

     C                   CallB     'ZFREQB'
     C                   Parm      *blanks       RetCodeIn         7
     C                   Parm                    ZFREQ             1
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZCCY              3
     C                   PARM                    ZLOC
     C                   Parm                    ZMDAY             2 0
     C                   Parm                    BJDFIN
     C                   Parm      SDGELR        SDGELR

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR
      *
      ***  Entry Parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode        7
     C                   PARM                    LNRFA             6
     C                   PARM                    WrkTotalRepay    18
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LE000036'    DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access general Ledger details.
      *
     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Determine if CLE028 is installed
      *
     C                   MOVE      'N'           CLE028            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE028'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE028
     C                   END
      *
      ***  Retrieve Loan Details
      *
     C     KEYLnrf       KLIST
     C                   KFLD                    K@LNRF            6
     C                   KFLD                    K@RCDT            1

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Standard DB Error processing                        *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVEL     'ERROR  '     ReturnCode
     C                   DUMP
     C                   MOVE      *ON           *INLR
     C                   CALL      'DBERRCTL'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
