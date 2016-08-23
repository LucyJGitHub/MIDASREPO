     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Validate Message Type If 103 OR 202')         *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT1020 - Midas FT Validate Message Type If 103 OR 202        *
      *                                                               *
      *  Function: This programs validates If message type is 103     *
      *            OR 202                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      *  Prev Amend No. BUG26775 *CREATE   Date 20Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG26775 - Validate message type If 103 OR 202               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 - Database Error                                        *
      *    U8 - Database Error                                        *
      *    LR - Last record found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External data structure for access programs
     D CUST          E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for access programs
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      ** External data structure for access programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** External data structure for Business Entity Identifier File
     D MEBEIS        E DS                  EXTNAME(MEBEISPD)
      ** External data structure for Midas BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      ** External data structure for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
     D WRun            S              1A
     D PACCT           S             35A
     D PCUST           S              7A
     D PCUST10A        S             10A
     D PKEY            S              7A
     D PTYPE           S              7A
     D INTYP           S              1A
     D ENTR1           S             35A
     D ENTR2           S             35A
     D SLSH            S              1A
     D W9PRAC          S              6A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Execute validation if Ordering Customer is not eqaul to 'MT202'
 
     C                   IF        CNTR1 <> 'MT202'
 
     C                   EXSR      ORD202
 
     C                   EXSR      BEN202
 
     C                   ELSE
 
     C                   EVAL      CTYP = 'B'
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ORD202 - Validate if Ordering Customer is a Bank
      *****************************************************************
 
     C     ORD202        BEGSR
 
     C                   EVAL      INTYP = CNTYP
     C                   EVAL      ENTR1 = CNTR1
     C                   EVAL      ENTR2 = CNTR2
     C                   EXSR      VOBBNK
 
     C                   IF        CTYP <> 'B'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   EVAL      CTYP = 'C'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  BEN202 - Validate if Beneficiary is a Bank
      *****************************************************************
 
     C     BEN202        BEGSR
 
     C                   EVAL      INTYP = BNTYP
     C                   EVAL      ENTR1 = BNTR1
     C                   EVAL      ENTR2 = BNTR2
     C                   EXSR      VOBBNK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VOBBNK - Validate Ordering Csutomer and Beneficiary
      *****************************************************************
 
     C     VOBBNK        BEGSR
 
     C                   EVAL      PACCT = ENTR1
 
     C                   MOVEL     ENTR1         SLSH
 
     C                   IF        INTYP = 'C' OR
     C                             INTYP = 'P' OR
     C                             INTYP = 'S'
 
      ** If not / then use first line
 
     C                   IF        SLSH <> '/'
     C                   MOVEL     ENTR1         W9BICC
     C     3             SUBST     ENTR1:9       W9BICB
     C     6             SUBST     ENTR1:1       W9PRAC
     C                   ELSE
     C                   MOVEL     ENTR2         W9BICC
     C     3             SUBST     ENTR2:9       W9BICB
     C     6             SUBST     ENTR1:2       W9PRAC
     C                   ENDIF
 
     C                   IF        INTYP = 'C'
     C                             OR INTYP = 'P'
 
     C                   IF        INTYP = 'C'
     C                   EVAL      @KEY1 = W9BICC
     C                   ELSE
     C                   EVAL      @KEY1 = W9PRAC
     C                   ENDIF
 
     C                   CALL      'AOCUSTR1'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     CUST          PARM      CUST          DSLDY
 
     C                   IF        @RTCD = *BLANKS
     C                   EXSR      BNIND
     C                   ENDIF
 
     C                   ELSEIF    INTYP = 'S'
 
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       W9RTN             7
     C                   PARM                    W9BICC            8
     C                   PARM                    W9BICB            3
     C                   PARM                    CUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
 
     C                   IF        W9CUST = 'Y'
 
     C                   EXSR      BNIND
 
     C                   ELSEIF    W9BICD = 'Y'
     C                   CALL      'AOBEISR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      BDSUBT        PBIC              4
     C     MEBEIS        PARM      MEBEIS        DSFDY
 
     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      CTYP = 'B'
     C                   ENDIF
 
     C                   ELSEIF    W9CNST = 'Y'
     C                   EVAL      CTYP = 'B'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      BBBNBI = *BLANKS
     C                   EVAL      BBSWFI = *BLANKS
     C                   EVAL      PCUST = *BLANKS
 
      ** Use AOIBANR2 to retrieve account details from IBAN entry
 
     C                   IF        INTYP = 'I'
 
     C                   IF        SLSH <> '/'
     C     34            SUBST     PACCT:1       PIBAN            34
     C                   ELSE
     C     34            SUBST     PACCT:2       PIBAN
     C                   ENDIF
 
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PIBAN
     C     ACCNT         PARM      *BLANKS       DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     CNUM          PCUST10A
     C                   EXSR      VCUST
     C                   ENDIF
 
     C                   ELSE
 
     C                   CALL      'AOACCTV1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      *BLANKS       PTYPE
     C                   PARM                    PACCT
     C                   PARM                    DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   SELECT
 
     C     PTYPE         WHENEQ    '*RETAIL'
     C     PTYPE         OREQ      '*LEDGER'
     C                   EVAL      ACCNT = DSSDY
     C                   MOVEL     CNUM          PCUST10A
     C                   EXSR      VCUST
 
     C     PTYPE         WHENEQ    '*CUSTNO'
     C     PTYPE         OREQ      '*SHNAME'
     C                   EVAL      CUST = DSSDY
 
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      BNIND
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *  BNIND - Bank Indicator
      *****************************************************************
 
     C     BNIND         BEGSR
 
     C                   IF        BBSWFI = 'Y'
     C                   EVAL      CTYP = 'B'
     C                   ELSEIF    BBSWFI <> 'N' AND BBBNBI = 'Y'
     C                   EVAL      CTYP = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VCUST - Validate Customer Number
      *****************************************************************
      *
     C     VCUST         BEGSR
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PCUST10A
     C                   PARM      *Blanks       PKEY
     C     CUST          PARM      CUST          DSSDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    CNTYP             1
     C                   PARM                    CNCCY             3
     C                   PARM                    CNTR1            35
     C                   PARM                    CNTR2            35
     C                   PARM                    CNTR3            35
     C                   PARM                    CNTR4            35
     C                   PARM                    CNTR5            35
     C                   PARM                    BNTYP             1
     C                   PARM                    BCCCY             3
     C                   PARM                    BNTR1            35
     C                   PARM                    BNTR2            35
     C                   PARM                    BNTR3            35
     C                   PARM                    BNTR4            35
     C                   PARM                    BNTR5            35
     C                   PARM                    CTYP              1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
