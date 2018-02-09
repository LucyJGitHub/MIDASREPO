     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment validation')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFEADVAL -  Fee Adjustment Validation                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG1304            Date 02Mar04               *
      *                 BUG1218            Date 01Mar04               *
      *                 CGP001             Date 04Dec03               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG1304- missing fee fields                                  *
      *  BUG1218- Status not shown                                    *
      *  CGP001 - Add name of 'MQ for Sent Messages' to PC Reference. *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  Fee Adjustment Details file
     FLEFEADL2  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Fee Adjustment Details in screen format
     D FEAD          E DS                  EXTNAME(LEFEADPD)
 
      ** Fee Settlement Details in file format
     D VFEAD         E DS                  EXTNAME(LEVFEADPD)
 
      ** Fee Adjustment Details OK indicator
     D FEAD_OK       E DS                  EXTNAME(LEEFEADPD)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *                                                                                       CLE106
      ** External SAR Details                                                                 CLE106
      *                                                                                       CLE106
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE106
                                                                                              CLE106
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                       CLE106
      **  Syndications Manager Switchable Feature                                             CLE106
      *                                                                                       CLE106
     D CLE106          S              1                                                       CLE106
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Clear output fields
 
     C                   Z-ADD     *ZERO         W#SADJ
     C                   MOVEL     *BLANK        S#SADE
 
     C                   MOVEL     *ALL'Y'       FEAD_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
      *
      * Validate Adjustment Amount
      *
     C                   EXSR      VLSADJ
      *
      * Validate Adjustment Sign
      *
     C                   EXSR      VLSIGN
 
      * Edit Adjustment Amount
 
     C     S#SIGN        IFEQ      '-'
     C                   Z-SUB     W#SADJ        FASADJ           13 0
     C                   ELSE
     C                   Z-ADD     W#SADJ        FASADJ                         *
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      FASADJ        ZFLD15
     C                   Z-ADD     FecyNBDP      ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        S#SADE
 
     C     ENDVAL        TAG
 
      * Set fields on insert and amend
 
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
     C                   EXSR      SETF_IA
     C                   ENDIF
 
     C                   RETURN
      *
      /SPACE 5
      *****************************************************************
      * Validate Adjustment Amount
      *****************************************************************
     C     VLSADJ        BEGSR
 
      * Amount must be defined
 
     C     S#SADJ        IFEQ      *BLANKS
     C                   MOVE      'N'           S#SADJok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SADJ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0192'     MsgIdArr(Ix)
 
     C                   ELSE
 
      * It must be a valid amount
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     S#SADJ        ZFIELD
     C                   Z-ADD     FecyNBDP      ZADEC
     C     13            SUB       ZADEC         ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           S#SADJok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SADJ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0192'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        W#SADJ
 
      * Amount must not be zero
     C     W#SADJ        IFEQ      *ZERO
     C                   MOVE      'N'           S#SADJok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SADJ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0192'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Adjustment Sign
      *****************************************************************
     C     VLSIGN        BEGSR
 
      * Sign defaults to '+' if blank
 
     C     S#SIGN        IFEQ      *BLANK
     C                   MOVE      '+'           S#SIGN
     C                   ENDIF
 
      * Sign must be '+' or '-'
 
     C     S#SIGN        IFNE      '+'
     C     S#SIGN        ANDNE     '-'
     C                   MOVE      'N'           S#SIGNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SIGN    '  FldNameArr(Ix)
     C                   MOVEL     'LER0169'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * SETF_IA  : Set fields on insert and amend                     *
      *****************************************************************
     C     SETF_IA       BEGSR
 
      ** Record Id
     C                   MOVE      'A'           ADRECI
 
      ** Adjustment
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      S#SADJ        ZFIELD
     C     13            SUB       FccyNBDP      ZADIG
     C                   Z-ADD     FccyNBDP      ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ADSADJ
 
      ** Sign
     C                   MOVE      S#SIGN        ADSIGN
 
      ** Action
     C                   MOVE      S#ACTN        ADACTN
 
      ** Branch code - alpha
     C                   MOVE      FcbrBranch    ADBRCA
 
      ** Customer number
     C                   MOVEL     S#CSSN        ADCNUM
 
      ** Facility
     C                   MOVEL     S#FACT        ADFACL
     C                   MOVE      S#FCNO        ADFACL
 
      ** Facility sequence number
     C                   MOVE      S#FSEQ        ADFSEQ
                                                                                              CLE073
      ** Loan                                                                                 CLE073
     C                   MOVE      S#LOAN        ADLOAN                                       CLE073
 
      ** Currency code
     C                   MOVE      S#FCCY        ADFCCY
 
      ** PC Transaction Reference
 
     C     P#MODE        IFEQ      'B'
     C     F5TNRF        ANDNE     *BLANK
     C     CLE106        OREQ      'Y'                                                        CLE106
     C                   MOVE      F5TNRF        ADPCRF
     C                   ELSE
     C     S#ACTN        IFEQ      'I'
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
                                                                                              CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD             7                          CLE148
     C                   PARM      'Y'           PUPDT             1                          CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT            8                          CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C     FcbrMQSM      IFNE      *BLANKS                                                    CGP001
     C                   MOVEL     FcbrMQSM      W1ST11                                       CGP001
     C                   ELSE                                                                 CGP001
     C                   MOVEL     FcbrBranch    W1ST11
     C                   ENDIF                                                                CGP001
     C                   MOVEL     W1ST11        ADPCRF
     C                   MOVE      '0001'        ADPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
     C                   ENDIF
 
      ** PC Originating Branch
 
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5PCOB        ADPCOB
     C                   ELSE
     C                   MOVE      *BLANKS       ADPCOB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANK        ZOUT21           21
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Fee Adjustment Details in screen format
     C                   PARM                    FEAD
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
      *
      * OUTPUTS
 
      * Status                                                                  BUG1218
     C                   PARM                    S#STAT           10            BUG1218
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Field OK flags
     C                   PARM                    FEAD_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
      * Valid Fee Adjustment
     C                   PARM                    VFEAD
 
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE106
      ** Access SAR Details                                                                   CLE106
      *                                                                                       CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALL      'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD             6                          CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
      *                                                                                       CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
 
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
