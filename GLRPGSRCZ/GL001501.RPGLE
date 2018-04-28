     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Account Key Generator')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001501 - Collateral Account Key Generator                  *
      *                                                               *
      *  Function:  This module will create account keys for the      *
      *             posting of contingent accounting entries in the   *
      *             collateral currency for each item in the          *
      *             collateral register that needs to generate        *
      *             accounting.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      *                 BUG28065           Date 24Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG17987           Date 15Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245680             Date 13Feb07               *
      *                 244201             Date 06Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG5857            Date 14Feb05               *
      *                 CLE041             Date 11Oct04               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG4392            Date 15Oct04               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG28065 - DBKEY still uses CDBRCA when the KAccnt is        *
      *             already using  CDCBRC                             *
      *  BUG17987 - Error on secured indicator                        *
      *  245680 - Ensure correct CDCLVP is stored on file.            *
      *  244201 - Changes for Extended Deal Subtype amendment.        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG5857 - GLC001501 00001 - failed due to wrong key field    *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  BUG4392 - Collatereal Value and blocked amount were not      *
      *            updated when collateral matures                    *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRAcctKeys - Generate account keys                           *
      *  SRGetDets  - Get collateral details                          *
      *  SRInitFlds - Initialise GLACKYPD fields                      *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Collateral Details select on RECI <> 'M'
     FGLCOLLLF  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FFCLTYL1   UF   E           K DISK    INFSR(*PSSR)                                     BUG17987
     F                                     COMMIT                                           BUG17987
     F                                     PREFIX(FD_)                                      BUG17987
                                                                                            BUG17987
     FGLCOLLL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG17987
     F                                     RENAME(GLCOLLD0:GLCOLLD1)                        BUG17987
     F                                     PREFIX(FC_)                                      BUG17987
                                                                                            BUG17987
      ** Midas GL Account Details                                                            BUG4392
     FACCNT     UF   E           K DISK    INFSR(*PSSR)                                      BUG4392
     F                                     COMMIT                                            BUG4392
                                                                                             BUG4392
      ** Midas DL Deals file                                                                 BUG4392
     FDEALS     UF   E           K DISK    INFSR(*PSSR)                                      BUG4392
     F                                     COMMIT                                            BUG4392
     F                                     IGNORE(DEALSDAF)                                  BUG4392
     F                                     IGNORE(DEALSDBF)                                  BUG4392
     F                                     IGNORE(DEALSDDF)                                  BUG4392
     F                                     IGNORE(DEALSDEF)                                  BUG4392
     F                                     IGNORE(DEALSDGF)                                  BUG4392
     F                                     IGNORE(DEALSDFF)                                  BUG4392
                                                                                             BUG4392
     FMMDEALLL  UF   E           K DISK    INFSR(*PSSR)                                      BUG4392
     F                                     COMMIT                                            BUG4392
     F                                     IGNORE(MMDENSP0)                                  BUG4392
     F                                     IGNORE(MMDENBP0)                                  BUG4392
                                                                                             BUG4392
      ** Midas GL Collateral Generated Account Keys Details
     FGLACKYPD  O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas GL Collateral Account Key Generator Error Report
     FGL001501P1O    E             PRINTER INFDS(SPOOL1)  USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WRPG            C                   CONST('rpg')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ArrUPPER        S              1    CTDATA DIM(26) PERRCD(26)
     D ArrLOWER        S              1    CTDATA DIM(26) PERRCD(26)
 
     D WAKEY           DS
     D   WType                 1      5
     D   WLoc                  6      8
     D   WChar                10     10
 
     D SPOOL1          DS
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D WSystem         DS
     D   WChar1                1      1
     D   WChar2                2      2
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA
 
      ** Data structure to hold Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter
     D PReturn         S              7
 
      ** Access object parameters
     D PRetCode        S              7
     D POption         S              7
 
     D WorkCREF        S             10
     D WorkCOLI        S             25
     D WorkAPCT        S              1
     D WorkNAMT        S             15  0
     D WorkPCNT        S              5  2
     D WorkVAMT        S             15  0
     D WNominal        S             15  0
     D WorkUPRC        S             15  8
     D WorkVPCH        S             15  0
     D WorkMNNA        S             15  0
     D WorkMXNA        S             15  0
     D WorkINSC        S              3
     D WorkINSW        S              2S 0
     D WorkINSP        S              3S 0
     D WorkCURC        S              3
     D WorkCURW        S              2S 0
     D WorkCURP        S              3S 0
     D WorkCTYC        S              2
     D WorkCTYW        S              2S 0
     D WorkCTYP        S              3S 0
     D WorkMARG        S              5  2
     D WorkLAMT        S             15  0
     D WPostAmnt       S             15  0
     D WCompLV         S             15  0
     D WEvntDate       S              5  0
     D WStrtEvnt       S              1
     D WCollIncr       S              1
     D WCollDecr       S              1
     D WExpEvent       S              1
     D WReversal       S              1
     D WRun            S              1
     D WChar5          S              5
     D WFolder         S              5
     D DIFLN1          S              3  0
     D RQDLN1          S              3  0
     D Idx             S              2  0
     D WCustNo         S              6                                                      BUG4392
     D WAccCde         S             10                                                      BUG4392
     D WAccSqe         S              2                                                      BUG4392
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
      ** Prototype for a Java String object
     D crtString       PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D   value                       10A   CONST VARYING
 
      ** Prototype for RPGWrapper object creation (instantiation)
     D crtCalcClass    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper':                         CLE041
     D                                     wrapper.access.RPGWrapper':                        CLE041
     D                                     *CONSTRUCTOR)
     D   value3                        O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
 
      ** Prototype for CalcClass' getCLVDetails method
     D getValues       PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper':                         CLE041
     D                                     wrapper.access.RPGWrapper':                        CLE041
     D                                     'getCLVDetails')
     D                                     CLASS(*JAVA:'java.lang.String')
     D   String1                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   String2                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   String3                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D***Int4***                     10I 0 VALUE                                              CSD027
     D   Int4                          O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D                                     CONST                                              CSD027
     D   String5                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
     D   String6                       O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
 
      ** Prototype for java string's getBytes method
     D cvtToBytes      PR           179A   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             'getBytes')
     D                                     VARYING
 
      ** Create CalcClass object field
     D CalcClassObj    S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D**********                           calculationmanager.collend.+                       CLE041
     D**********                           wrapper.as400.RPGWrapper')                         CLE041
     D                                     wrapper.access.RPGWrapper')                        CLE041
 
      ** Create string objects
     D Parm1           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm2           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm3           S               O   CLASS(*JAVA:'java.lang.String')
     D*Parm4****       S             10I 0                                                    CSD027
     D Parm4           S               O   CLASS(*JAVA:'java.lang.String')                    CSD027
     D Parm5           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm6           S               O   CLASS(*JAVA:'java.lang.String')
     D Parm7           S               O   CLASS(*JAVA:'java.lang.String')
     D RcvParms        S               O   CLASS(*JAVA:'java.lang.String')
 
     D WRcvStr         S            179A   VARYING
     D WRcvFld1        S             25
     D WRcvFld2        S              1
     D WRcvFld3        S             15
     D WRcvFld4        S             15
     D WRcvFld5        S             15
     D WRcvFld6        S             15
     D WRcvFld7        S             15
     D WRcvFld8        S             15
     D WRcvFld9        S             15
     D WRcvFld10       S             15
     D WRcvFld11       S              3
     D WRcvFld12       S              2
     D WRcvFld13       S              3
     D WRcvFld14       S              3
     D WRcvFld15       S              2
     D WRcvFld16       S              3
     D WRcvFld17       S              2
     D WRcvFld18       S              2
     D WRcvFld19       S              3
     D WRcvFld20       S              5
     D WRcvFld21       S             15
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      *                                                               *
      *  MAIN PROCEDURE                                               *
      *                                                               *
      *****************************************************************
 
     C     KCOLL         KLIST                                                              BUG17987
     C                   KFLD                    KCDMODS           2                        BUG17987
     C                   KFLD                    KCDFCUS           6                        BUG17987
     C                   KFLD                    KCDFTYP           3 0                      BUG17987
     C                   KFLD                    KCDFSEQ           2 0                      BUG17987
      *                                                                                     BUG17987
     C     KFCTL         KLIST                                                              BUG17987
     C                   KFLD                    KBRCA             3                        BUG17987
     C                   KFLD                    KCNUM             6                        BUG17987
     C                   KFLD                    KFACT             3 0                      BUG17987
     C                   KFLD                    KFCNO             2 0                      BUG17987
      *                                                                                     BUG17987
     C     *LOVAL        SETLL     GLCOLLLF
     C                   READ      GLCOLLLF
 
      ** Read through all collateral detail records with CDRECI <> 'M'
 
     C                   DOW       NOT %EOF(GLCOLLLF)
 
     C                   SELECT
 
      ** Reversed record
 
     C                   WHEN      CDRECI = 'R'
     C                   IF        CDLCD = BJRDNB
     C                   IF        CDCLVP <> *ZERO
     C                   EVAL      WReversal = 'Y'
     C                   EVAL      WPostAmnt = CDCLVP
     C                   EVAL      WEvntDate = BJRDNB
     C                   EXSR      SRAcctKeys
     C                   EVAL      CDCLVP = *ZERO
     C                   ENDIF
     C                   ENDIF
 
      ** Live record
 
     C                   WHEN      CDRECI = 'D'
 
      ** Value date is before date of next working day
 
     C                   IF        CDVDAT < BJDNWD
 
      ** Start date postings not yet generated
 
     C                   IF        CDSTGN <> 'Y'
 
     C                   IF        CDGENA = 'Y'
     C                   EXSR      SRGetDets
     C                   EVAL      WPostAmnt = WorkLAMT
 
     C                   IF        WPostAmnt <> *ZERO
     C                   EVAL      WStrtEvnt = 'Y'
     C                   EVAL      WEvntDate = CDVDAT
     C                   EXSR      SRAcctKeys
     C                   EVAL      CDSTGN = 'Y'
     C                   EVAL      CDCLVP = WorkLAMT
     C                   ENDIF
     C                   ENDIF
 
      ** Start date postings generated
 
     C                   ELSE
 
     C                   IF        CDGENA = 'Y'
     C                   EXSR      SRGetDets
     C                   EVAL      WCompLV = WorkLAMT
     C                   ELSE
     C                   EVAL      WCompLV = *ZERO
     C                   ENDIF
 
     C                   EVAL      WPostAmnt = WCompLV - CDCLVP
     C                   EVAL      CDCLVP = WCompLV                                           245680
 
     C                   IF        WPostAmnt <> *ZERO
     C                   IF        WPostAmnt > *ZERO
     C                   EVAL      WCollIncr = 'Y'
     C                   ELSE
     C                   EVAL      WCollDecr = 'Y'
     C                   EVAL      WPostAmnt = 0 - WPostAmnt
     C                   ENDIF
     C                   EVAL      WEvntDate = BJRDNB
     C                   EXSR      SRAcctKeys
     C**********         EVAL      CDCLVP = WCompLV                                           245680
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** End date is before date of next working day
 
     C                   IF        CDEDAT <> *ZEROS AND
     C                             CDEDAT < BJDNWD
     C                   IF        CDCLVP <> *ZERO
     C                   EVAL      WPostAmnt = CDCLVP
     C                   EVAL      WExpEvent = 'Y'
     C                   EVAL      WEvntDate = CDEDAT
     C                   EXSR      SRAcctKeys
     C                   ENDIF
     C                   EVAL      CDRECI = 'M'
     C                   EVAL      CDSTAT = 'E'
     C                   EVAL      CDCLVP = *ZERO
                                                                                             BUG4392
     C                   SELECT                                                              BUG4392
     C                   WHEN      CDCOPT = 'A'                                              BUG4392
     C                   EXSR      SRAccnt                                                   BUG4392
     C                   WHEN      CDCOPT = 'D'                                              BUG4392
     C                   EXSR      SRDeal                                                    BUG4392
     C                   ENDSL                                                               BUG4392
                                                                                             BUG4392
      *                                                                                     BUG17987
      ** Check if facility cust, type & seq is present                                      BUG17987
      *                                                                                     BUG17987
     C                   IF        CDMODS <> *BLANKS AND                                    BUG17987
     C                             CDFCUS <> *BLANKS AND                                    BUG17987
     C                             CDFTYP <> *ZERO   AND                                    BUG17987
     C                             CDFSEQ <> *ZERO                                          BUG17987
      *                                                                                     BUG17987
     C                   EVAL      KCDMODS = CDMODS                                         BUG17987
     C                   EVAL      KCDFCUS = CDFCUS                                         BUG17987
     C                   EVAL      KCDFTYP = CDFTYP                                         BUG17987
     C                   EVAL      KCDFSEQ = CDFSEQ                                         BUG17987
      *                                                                                     BUG17987
      ** Check if other collateral share the same facility                                  BUG17987
      *                                                                                     BUG17987
     C     KCOLL         SETLL     GLCOLLL3                                                 BUG17987
     C                   READ      GLCOLLL3                                                 BUG17987
     C                   Z-ADD     0             LIVREC                                     BUG17987
     C                   DOW       NOT %EOF(GLCOLLL3)                                       BUG17987
      *                                                                                     BUG17987
     C                   IF        FC_CDMODS = CDMODS AND                                   BUG17987
     C                             FC_CDFCUS = CDFCUS AND                                   BUG17987
     C                             FC_CDFTYP = CDFTYP AND                                   BUG17987
     C                             FC_CDFSEQ = CDFSEQ AND                                   BUG17987
     C                             FC_CDRECI = 'D'                                          BUG17987
     C                   ADD       1             LIVREC            3 0                      BUG17987
     C                   ENDIF                                                              BUG17987
     C                   EVAL      KBRCA = FC_CDFBRC                                        BUG17987
     C                   READ      GLCOLLL3                                                 BUG17987
     C                   IF        FC_CDMODS <> CDMODS OR                                   BUG17987
     C                             FC_CDFCUS <> CDFCUS OR                                   BUG17987
     C                             FC_CDFTYP <> CDFTYP OR                                   BUG17987
     C                             FC_CDFSEQ <> CDFSEQ                                      BUG17987
      *                                                                                     BUG17987
      ** Update facility secured indicator if no other live collateral                      BUG17987
      *                                                                                     BUG17987
     C                   IF        LIVREC = 1                                               BUG17987
     C                   EVAL      KCNUM = CDFCUS                                           BUG17987
     C                   EVAL      KFACT = CDFTYP                                           BUG17987
     C                   EVAL      KFCNO = CDFSEQ                                           BUG17987
     C     KFCTL         CHAIN     FCLTYL1                                                  BUG17987
     C                   IF        %FOUND(FCLTYL1)                                          BUG17987
     C                   EVAL      FD_SECI = 'N'                                            BUG17987
     C                   UPDATE    FCLTYFMF                                                 BUG17987
     C                   ENDIF                                                              BUG17987
     C                   ENDIF                                                              BUG17987
     C                   LEAVE                                                              BUG17987
     C                   ENDIF                                                              BUG17987
     C                   ENDDO                                                              BUG17987
     C                   ENDIF                                                              BUG17987
     C                   ENDIF
     C                   ENDSL
 
      ** Update Collateral details file
 
     C                   UPDATE    GLCOLLD0
 
     C                   READ      GLCOLLLF
     C                   ENDDO
 
      ** Commit changes
 
     C                   COMMIT
 
     C                   EVAL      *INLR = *ON
 
     C                   CLOSE     GL001501P1
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcctKeys - Generate account keys                           *
      *                                                               *
      *****************************************************************
     C     SRAcctKeys    BEGSR
 
      ** Initialise file fields
 
     C                   EXSR      SRInitFlds
 
     C                   EVAL      GLRECI = 'D'
     C                   EVAL      WType = CDCOLT
     C                   EVAL      WLoc = CDCOLO
 
      ** Start event
 
     C                   IF        WStrtEvnt = 'Y'
     C                   EVAL      WChar = 'S'
     C                   ENDIF
 
      ** Collateral Increase
 
     C                   IF        WCollIncr = 'Y'
     C                   EVAL      WChar = 'I'
     C                   ENDIF
 
      ** Collateral Decrease
 
     C                   IF        WCollDecr = 'Y'
     C                   EVAL      WChar = 'D'
     C                   ENDIF
 
      ** Expiry Event
 
     C                   IF        WExpEvent = 'Y'
     C                   EVAL      WChar = 'E'
     C                   ENDIF
 
      ** Reversal
 
     C                   IF        WReversal = 'Y'
     C                   EVAL      WChar = 'E'
     C                   ENDIF
 
     C                   EVAL      GLAKEY = WAKEY
     C                   EVAL      GLCREF = CDCREF
     C                   EVAL      GLCNUM = CDCNUM
     C                   EVAL      GLBRCA = CDBBRC
     C                   EVAL      GLEDAT = WEvntDate
     C                   EVAL      GLEAMT = WPostAmnt
     C                   EVAL      GLECCY = CDCCY
     C                   EVAL      GLCOPT = CDCOPT
     C                   EVAL      GLPLAM = CDCLVP
 
     C                   IF        WStrtEvnt = 'Y'  OR  WCollIncr = 'Y'  OR
     C                             WCollDecr = 'Y'
     C                   IF        CDGENA = 'Y'
     C                   EVAL      GLCOLI = WorkCOLI
     C                   EVAL      GLAPCT = WorkAPCT
     C                   EVAL      GLNAMT = WorkNAMT
     C                   EVAL      GLPCNT = WorkPCNT
     C                   EVAL      GLVALA = WorkVAMT
     C                   EVAL      GLNOML = WNominal
     C                   EVAL      GLPRIC = WorkUPRC
     C                   EVAL      GLVPCH = WorkVPCH
     C                   EVAL      GLMNNA = WorkMNNA
     C                   EVAL      GLMXNA = WorkMXNA
     C                   EVAL      GLINSC = WorkINSC
     C                   EVAL      GLINSW = WorkINSW
     C                   EVAL      GLINSP = WorkINSP
     C                   EVAL      GLCURC = WorkCURC
     C                   EVAL      GLCURW = WorkCURW
     C                   EVAL      GLCURP = WorkCURP
     C                   EVAL      GLCTYC = WorkCTYC
     C                   EVAL      GLCTYW = WorkCTYW
     C                   EVAL      GLCTYP = WorkCTYP
     C                   EVAL      GLMARG = WorkMARG
     C                   EVAL      GLLAMT = WorkLAMT
     C                   ENDIF
     C                   ENDIF
 
     C                   WRITE     GLACKYD0
 
      ** Reset work fields
 
     C                   EVAL      WReversal = *BLANK
     C                   EVAL      WStrtEvnt = *BLANK
     C                   EVAL      WCollIncr = *BLANK
     C                   EVAL      WCollDecr = *BLANK
     C                   EVAL      WExpEvent = *BLANK
     C                   EVAL      WAKEY = *BLANKS
     C                   EVAL      WPostAmnt = *ZERO
     C                   EVAL      WEvntDate = *ZERO
     C                   EVAL      WCompLV = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetDets - Get collateral details                           *
      *                                                               *
      *****************************************************************
     C     SRGetDets     BEGSR
 
      ** Create java string objects for all parameters to be passed to getCLVDetails
 
     C                   EVAL      Parm1 = crtString(CDCREF)
     C                   EVAL      Parm2 = crtString(CDCOPT)
     C                   EVAL      Parm3 = crtString(CDCSBR)
     C*****              EVAL      Parm4 = CDCSCN                                             CSD027
     C                   EVAL      Parm4 = crtString(CDCSCN)                                  CSD027
     C                   EVAL      Parm5 = crtString(CDPTFR)
     C                   EVAL      Parm6 = crtString(CDCSEC)
 
      ** Invoke the getCLVDetails method of the CalcClass object
 
     C                   EVAL      RcvParms = getValues(CalcClassObj:
     C                                                  Parm1:
     C                                                  Parm2:
     C                                                  Parm3:
     C                                                  Parm4:
     C                                                  Parm5:
     C                                                  Parm6)
 
      ** Convert the received java string to RPG bytes (Varying alpha field)
 
     C                   EVAL      WRcvStr = cvtToBytes(RcvParms)
 
     C                   MOVEL     WRcvStr       WChar5
 
      ** Set all return fields to blanks or zeroes if error occurs
 
     C                   IF        WChar5 = 'ERROR'
     C                   EVAL      WorkCOLI = *BLANKS
     C                   EVAL      WorkAPCT = *BLANKS
     C                   EVAL      WorkNAMT = *ZERO
     C                   EVAL      WorkPCNT = *ZERO
     C                   EVAL      WorkVAMT = *ZERO
     C                   EVAL      WNominal = *ZERO
     C                   EVAL      WorkUPRC = *ZERO
     C                   EVAL      WorkVPCH = *ZERO
     C                   EVAL      WorkMNNA = *ZERO
     C                   EVAL      WorkMXNA = *ZERO
     C                   EVAL      WorkINSC = *BLANKS
     C                   EVAL      WorkINSW = *ZERO
     C                   EVAL      WorkINSP = *ZERO
     C                   EVAL      WorkCURC = *BLANKS
     C                   EVAL      WorkCURW = *ZERO
     C                   EVAL      WorkCURP = *ZERO
     C                   EVAL      WorkCTYC = *BLANKS
     C                   EVAL      WorkCTYW = *ZERO
     C                   EVAL      WorkCTYP = *ZERO
     C                   EVAL      WorkMARG = *ZERO
     C                   EVAL      WorkLAMT = *ZERO
     C                   EXSR      SRReport
 
      ** Retrieve all fields from received string via substring function
 
     C                   ELSE
     C                   EVAL      WRcvFld1 = %SUBST(WRcvStr:1:25)
     C                   EVAL      WRcvFld2 = %SUBST(WRcvStr:26:1)
     C                   EVAL      WRcvFld3 = %SUBST(WRcvStr:27:15)
     C                   EVAL      WRcvFld4 = %SUBST(WRcvStr:42:5)
     C                   EVAL      WRcvFld5 = %SUBST(WRcvStr:47:15)
     C                   EVAL      WRcvFld6 = %SUBST(WRcvStr:62:15)
     C                   EVAL      WRcvFld7 = %SUBST(WRcvStr:77:15)
     C                   EVAL      WRcvFld8 = %SUBST(WRcvStr:92:15)
     C                   EVAL      WRcvFld9 = %SUBST(WRcvStr:107:15)
     C                   EVAL      WRcvFld10 = %SUBST(WRcvStr:122:15)
     C                   EVAL      WRcvFld11 = %SUBST(WRcvStr:137:3)
     C                   EVAL      WRcvFld12 = %SUBST(WRcvStr:140:2)
     C                   EVAL      WRcvFld13 = %SUBST(WRcvStr:142:3)
     C                   EVAL      WRcvFld14 = %SUBST(WRcvStr:145:3)
     C                   EVAL      WRcvFld15 = %SUBST(WRcvStr:148:2)
     C                   EVAL      WRcvFld16 = %SUBST(WRcvStr:150:3)
     C                   EVAL      WRcvFld17 = %SUBST(WRcvStr:153:2)
     C                   EVAL      WRcvFld18 = %SUBST(WRcvStr:155:2)
     C                   EVAL      WRcvFld19 = %SUBST(WRcvStr:157:3)
     C                   EVAL      WRcvFld20 = %SUBST(WRcvStr:160:5)
     C                   EVAL      WRcvFld21 = %SUBST(WRcvStr:165:15)
 
     C                   MOVEL     WRcvFld1      WorkCOLI
     C                   MOVEL     WRcvFld2      WorkAPCT
     C                   MOVEL     WRcvFld3      WorkNAMT
     C                   MOVEL     WRcvFld4      WorkPCNT
     C                   MOVEL     WRcvFld5      WorkVAMT
     C                   MOVEL     WRcvFld6      WNominal
     C                   MOVEL     WRcvFld7      WorkUPRC
     C                   MOVEL     WRcvFld8      WorkVPCH
     C                   MOVEL     WRcvFld9      WorkMNNA
     C                   MOVEL     WRcvFld10     WorkMXNA
     C                   MOVEL     WRcvFld11     WorkINSC
     C                   MOVEL     WRcvFld12     WorkINSW
     C                   MOVEL     WRcvFld13     WorkINSP
     C                   MOVEL     WRcvFld14     WorkCURC
     C                   MOVEL     WRcvFld15     WorkCURW
     C                   MOVEL     WRcvFld16     WorkCURP
     C                   MOVEL     WRcvFld17     WorkCTYC
     C                   MOVEL     WRcvFld18     WorkCTYW
     C                   MOVEL     WRcvFld19     WorkCTYP
     C                   MOVEL     WRcvFld20     WorkMARG
     C                   MOVEL     WRcvFld21     WorkLAMT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitFlds - Initialise GLACKYPD fields                      *
      *                                                               *
      *****************************************************************
     C     SRInitFlds    BEGSR
 
     C                   EVAL      GLRECI = *BLANKS
     C                   EVAL      GLAKEY = *BLANKS
     C                   EVAL      GLCREF = *BLANKS
     C**********         EVAL      GLCNUM = *ZERO                                             CSD027
     C                   EVAL      GLCNUM = *BLANKS                                           CSD027
     C                   EVAL      GLBRCA = *BLANKS
     C                   EVAL      GLASQN = *ZERO
     C                   EVAL      GLEDAT = *ZERO
     C                   EVAL      GLEAMT = *ZERO
     C                   EVAL      GLECCY = *BLANKS
     C                   EVAL      GLREVI = *ZERO
     C                   EVAL      GLSETP = *ZERO
     C                   EVAL      GLSTAC = *BLANKS
     C                   EVAL      GLSTBR = *BLANKS
     C                   EVAL      GLSTCY = *BLANKS
     C                   EVAL      GLFACO = *BLANKS
     C                   EVAL      GLPRFC = *BLANKS
     C                   EVAL      GLBOKC = *BLANKS
     C                   EVAL      GLPTFR = *BLANKS
     C                   EVAL      GLCOLI = *BLANKS
     C                   EVAL      GLCOPT = *BLANKS
     C                   EVAL      GLAPCT = *BLANKS
     C                   EVAL      GLNAMT = *ZERO
     C                   EVAL      GLPCNT = *ZERO
     C                   EVAL      GLVALA = *ZERO
     C                   EVAL      GLNOML = *ZERO
     C                   EVAL      GLPRIC = *ZERO
     C                   EVAL      GLVPCH = *ZERO
     C                   EVAL      GLMNNA = *ZERO
     C                   EVAL      GLMXNA = *ZERO
     C                   EVAL      GLINSC = *BLANKS
     C                   EVAL      GLINSW = *ZERO
     C                   EVAL      GLINSP = *ZERO
     C                   EVAL      GLCURC = *BLANKS
     C                   EVAL      GLCURW = *ZERO
     C                   EVAL      GLCURP = *ZERO
     C                   EVAL      GLCTYC = *BLANKS
     C                   EVAL      GLCTYW = *ZERO
     C                   EVAL      GLCTYP = *ZERO
     C                   EVAL      GLMARG = *ZERO
     C                   EVAL      GLLAMT = *ZERO
     C                   EVAL      GLPLAM = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Report Errors Encountered in Calculator           *
      *                                                               *
      *****************************************************************
 
     C     SRReport      BEGSR
 
     C                   MOVEL     CDCREF        RCDCREF
     C                   EVAL      RCDDESC = 'ERROR OCCURRED IN CALCULATOR +
     C                                       PROCESSING'
 
      ** Check that sufficient lines remain for the format
 
     C                   EVAL      RQDLN1 = 2
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG4392
      *                                                               *                      BUG4392
      *  SRAccnt - Update Collateral details on Account Details file  *                      BUG4392
      *                                                               *                      BUG4392
      *****************************************************************                      BUG4392
     C     SRAccnt       BEGSR                                                               BUG4392
                                                                                             BUG4392
     C     KAccnt        KLIST                                                               BUG4392
     C                   KFLD                    CDCCNM                                      BUG4392
     C                   KFLD                    CDCCCY                                      BUG4392
     C                   KFLD                    CDCACD                                      BUG4392
     C                   KFLD                    CDCSEQ                                      BUG4392
     C**********         KFLD                    CDBRCA                              BUG4392 BUG5857
     C                   KFLD                    CDCBRC                                      BUG5857
                                                                                             BUG4392
     C     KAccnt        CHAIN     ACCNT                                                     BUG4392
                                                                                             BUG4392
     C                   IF        NOT %FOUND(ACCNT)                                         BUG4392
     C                   MOVE      CDCCNM        WCustNo                                     BUG4392
     C                   MOVE      CDCACD        WAccCde                                     BUG4392
     C                   MOVE      CDCSEQ        WAccSqe                                     BUG4392
     C                   EVAL      DBASE = 2                                                 BUG4392
     C                   EVAL      DBKEY = WCustNo + CDCCCY + WAccCde +                      BUG4392
     C**********                           WAccSqe + CDBRCA                         BUG4392 BUG28065
     C                                     WAccSqe + CDCBRC                                 BUG28065
     C                   EVAL      DBFILE = 'ACCNT'                                          BUG4392
     C                   EXSR      *PSSR                                                     BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
      ** Update Blocked collateral                                                           BUG4392
                                                                                             BUG4392
     C                   IF        CDAPCT = 'A'                                              BUG4392
     C                   EVAL      BCOA = BCOA - CDNAMT                                      BUG4392
     C                   EVAL      COLA = COLA - CDNAMT                                      BUG4392
     C                   ELSE                                                                BUG4392
     C                   EVAL      BCOA = BCOA - CDMNNA                                      BUG4392
     C                   EVAL      COLA = COLA - CDMNNA                                      BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
     C                   IF        COLA <= *ZERO                                             BUG4392
     C                   EVAL      COLF = 'N'                                                BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
     C                   UPDATE    ACCNTABF                                                  BUG4392
                                                                                             BUG4392
     C                   ENDSR                                                               BUG4392
      *****************************************************************                      BUG4392
      /EJECT                                                                                 BUG4392
      *****************************************************************                      BUG4392
      *                                                               *                      BUG4392
      *  SRDeal - Update Collateral details on Deals file             *                      BUG4392
      *                                                               *                      BUG4392
      *****************************************************************                      BUG4392
     C     SRDeal        BEGSR                                                               BUG4392
                                                                                             BUG4392
     C     CDDeal        CHAIN     DEALS                                                     BUG4392
                                                                                             BUG4392
     C                   IF        NOT %FOUND(DEALS)                                         BUG4392
     C                   EVAL      DBASE = 3                                                 BUG4392
     C                   MOVE      CDDEAL        DBKEY                                       BUG4392
     C                   EVAL      DBFILE = 'DEALSDC'                                        BUG4392
     C                   EXSR      *PSSR                                                     BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
      ** Update Blocked collateral                                                           BUG4392
                                                                                             BUG4392
     C                   IF        CDAPCT = 'A'                                              BUG4392
     C                   EVAL      BCAM = BCAM - CDNAMT                                      BUG4392
     C                   EVAL      COLA = COLA - CDNAMT                                      BUG4392
     C                   ELSE                                                                BUG4392
     C                   EVAL      BCAM = BCAM - CDMNNA                                      BUG4392
     C                   EVAL      COLA = COLA - CDMNNA                                      BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
     C                   IF        COLA <= *ZERO                                             BUG4392
     C                   EVAL      COLF = 'N'                                                BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
     C                   UPDATE    DEALSDCF                                                  BUG4392
                                                                                             BUG4392
      ** Update for MMDELDPP                                                                 BUG4392
                                                                                             BUG4392
     C     CDDEAL        CHAIN     MMDEALLL                                                  BUG4392
                                                                                             BUG4392
     C                   IF        NOT %FOUND(MMDEALLL)                                      BUG4392
     C                   EVAL      DBASE = 4                                                 BUG4392
     C                   MOVE      CDDEAL        DBKEY                                       BUG4392
     C                   EVAL      DBFILE = 'MMDEALLL'                                       BUG4392
     C                   EXSR      *PSSR                                                     BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
      ** Update Blocked collateral                                                           BUG4392
                                                                                             BUG4392
     C                   IF        CDAPCT = 'A'                                              BUG4392
     C                   EVAL      HKBCAM = HKBCAM - CDNAMT                                  BUG4392
     C                   EVAL      HKCOLA = HKCOLA - CDNAMT                                  BUG4392
     C                   ELSE                                                                BUG4392
     C                   EVAL      HKBCAM = HKBCAM - CDMNNA                                  BUG4392
     C                   EVAL      HKCOLA = HKCOLA - CDMNNA                                  BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
     C                   IF        HKCOLA <= *ZERO                                           BUG4392
     C                   EVAL      HKCOLF = 'N'                                              BUG4392
     C                   ENDIF                                                               BUG4392
                                                                                             BUG4392
     C                   UPDATE    MMDELDP0                                                  BUG4392
                                                                                             BUG4392
     C                   ENDSR                                                               BUG4392
      *****************************************************************                      BUG4392
      /EJECT                                                                                 BUG4392
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturn
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise work fields
 
     C                   EVAL      PReturn = *BLANKS
     C                   EVAL      WReversal = *BLANK
     C                   EVAL      WStrtEvnt = *BLANK
     C                   EVAL      WCollIncr = *BLANK
     C                   EVAL      WCollDecr = *BLANK
     C                   EVAL      WExpEvent = *BLANK
     C                   EVAL      WAKEY = *BLANKS
     C                   EVAL      WPostAmnt = *ZERO
     C                   EVAL      WEvntDate = *ZERO
     C                   EVAL      WCompLV = *ZERO
 
     C                   OPEN      GL001501P1
 
     C                   IN        SDSTAT
     C                   EVAL      WSystem = LIBR
 
     C                   EVAL      Idx = 1
     C     WChar1        LOOKUP    ArrUPPER(Idx)                          89
 
     C                   IF        *IN89 = *ON
     C                   EVAL      WChar1 = ArrLOWER(Idx)
     C                   ENDIF
 
     C                   EVAL      Idx = 1
     C     WChar2        LOOKUP    ArrUPPER(Idx)                          89
 
     C                   IF        *IN89 = *ON
     C                   EVAL      WChar2 = ArrLOWER(Idx)
     C                   ENDIF
 
     C     WSystem       CAT       WRPG          WFolder
 
     C                   EVAL      Parm7 = crtString(WFolder)
 
      ** Create/Instantiate "CalcClass" java object (one time only)
      ** so as to access its "getCLVDetails" method later
 
     C                   EVAL      CalcClassObj = crtCalcClass(Parm7)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   ROLBK
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   ENDIF
 
     C                   EVAL      PReturn = '*ERROR '
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
** ArrUPPER
ABCDEFGHIJKLMNOPQRSTUVQXYZ
** ArrLOWER
abcdefghijklmnopqrstuvwxyz
