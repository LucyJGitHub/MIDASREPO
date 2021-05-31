     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee settlement validation')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFESTVAL -  Fee Settlement Validation                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054354           Date 23Oct19               *
      *  Prev Amend No. MD026969A          Date 23Oct19               *
      *                 MD026969           Date 23Oct19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 223947             Date 16Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054354 - Settlement of fee accrual for prior period for    *
      *             backdated notional change                         *
      *  MD026969A - Further modifications.                           *
      *           - Applied for MD054354                              *
      *  MD026969 - New Processing for Fee Settlement.                *
      *           - Applied for MD054354                              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            CCR016: Settlement Allocation                      *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancement Phase 1 Priority 1A             *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  223947 - 3rd reopen of Bug678. Corrections & omissions.      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Valid file changed to match LEFEEAD                 *
      *         - Status not shown                                    *
      *         - Only default settlement amount if Type = 'F' or 'W'.*
      *         - Amendments to the settlement instructions were lost.*
      *         - PC Reference should use branch code if A8MQSM blank.*
      *         - A newly inserted Fee Settlement picked up the User  *
      *           Profiles from a previous record.                    *
      *         - Amending an authorised Fee Settlement changed its   *
      *           status to 'Complete' & cleared User profiles etc.   *
      *         - Initialise CLE031 exchange rate fields to prevent   *
      *           database error.                                     *
      *         - Missing fields on display                           *
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
     FLEFZASL2  IF   E           K DISK    INFSR(*PSSR)                                    MD026969A
 
 
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
      ** Zero Past Due Fee Settlement                                                       MD054354
     D PDFeeSttmt      C                   Const('ZeroPDFeeSettlements')                    MD054354
                                                                                            MD054354
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Fee Settlement Details in screen format
     D FEST          E DS                  EXTNAME(LEFESTPD)
 
      ***Fee*Settlement Details in file format                                                CAP084
      ** Current Fee Settlement Details in file format                                        CAP084
     D LEFESTFmt     E DS                  EXTNAME(LEFEEAD)                                   CAP084
                                                                                              CAP084
      ** Valid Fee Settlement Details in file format                                          CAP084
     D VFEST         E DS                  EXTNAME(LEVFESTPD)
     D QQOURS1       E                     EXTFLD(QQOURS)                                     CGL029
 
      ** Saved Valid Fee Settlement Details in file format                                    CAP084
     D SAVFEST       E DS                  EXTNAME(LEVFESTPD) PREFIX(SV)                      CAP084
                                                                                              CAP084
      ** Fee Settlement Details OK indicator
     D FEST_OK       E DS                  EXTNAME(LEEFESTPD)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details                                                          CLE106
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
     D CLE106          S              1A                                                      CLE106
     D WKSADJ          S             13  0 INZ(0)                                          MD026969A
     D W#CNUM          S              6A                                                   MD026969A
     D W#FACL          S              5S 0                                                 MD026969A
     D W#FSEQ          S              2S 0                                                 MD026969A
 
     D PRTCD           S              7A                                                      CLE148
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148
     D PSysVal01       S             20A                                                    MD054354
     D PCurSet01       S            200A                                                    MD054354
     D PSysVal02       S             20A                                                    MD054354
     D PCurSet02       S            200A                                                    MD054354
     D PSysVal03       S             20A                                                    MD054354
     D PCurSet03       S            200A                                                    MD054354
     D PSysVal04       S             20A                                                    MD054354
     D PCurSet04       S            200A                                                    MD054354
     D PSysVal05       S             20A                                                    MD054354
     D PCurSet05       S            200A                                                    MD054354
     D PSysVal06       S             20A                                                    MD054354
     D PCurSet06       S            200A                                                    MD054354
     D PSysVal07       S             20A                                                    MD054354
     D PCurSet07       S            200A                                                    MD054354
     D PSysVal08       S             20A                                                    MD054354
     D PCurSet08       S            200A                                                    MD054354
     D PSysVal09       S             20A                                                    MD054354
     D PCurSet09       S            200A                                                    MD054354
     D PSysVal10       S             20A                                                    MD054354
     D PCurSet10       S            200A                                                    MD054354
                                                                                            MD054354
 
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
 
     C                   MOVEL     *ALL'Y'       FEST_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
     C                   MOVE      *BLANK        CLE031            1                          CAP084
     C     S#ACTN        IFEQ      'I'                                                        CAP084
     C                   MOVEL     *BLANKS       VFEST                                        CAP084
     C                   ELSE                                                                 CAP084
      * Save previous values of fields such as Inserting User Profile:                        CAP084
     C                   EXSR      SAVFLD                                                     CAP084
     C                   ENDIF                                                                CAP084
      *
      * Validate Settlement Amount
      *
     C                   EXSR      VLSADJ
      *
      * Validate Type
      *
     C                   EXSR      VLTYPE
      *
      * Validate Settlement Amount & Type
      *
     C     S#SADJok      IFNE      'N'
     C     S#TYPEok      ANDNE     'N'
     C                   EXSR      VLSADJTYPE
     C                   ENDIF
 
      * Edit Settlement Amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      W#SADJ        ZFLD15
     C                   Z-ADD     FecyNBDP      ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        S#SADE
 
      * Set fields on insert and amend
 
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
     C     S#ACTN        OREQ      'D'
     C                   EXSR      SETF_IA
     C                   ENDIF
 
     C     ENDVAL        TAG
      *
     C********           MOVEL     S#ACTN        STTYLC                                       CAP084
      *
     C                   RETURN
      *
      /SPACE 5
      *****************************************************************
      * Validate Settlement Amount
      *****************************************************************
     C     VLSADJ        BEGSR
 
      * If amount not defined, set it to fee amount past due
 
     C     S#SADJ        IFEQ      *BLANKS
     C     S#TYPE        IFEQ      'F'                                                        CAP084
     C     S#TYPE        OREQ      'W'                                                        CAP084
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      W#CPAM        ZFIELD
     C                   Z-ADD     FecyNBDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        S#SADJ
 
     C                   ENDIF                                                                CAP084
     C                   ENDIF
 
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
     C                   MOVEL     'LER0191'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        W#SADJ
      * Amount must not be zero
     C     W#SADJ        IFEQ      *ZERO
     C                   MOVE      'N'           S#SADJok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SADJ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0191'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   IF        PDFeeSet = 'Y'                                           MD054354
      *                                                                                    MD026969A
      ** Must exist in new file if W#CPAM = 0 and Partial settlement                       MD026969A
      ** and settlement amount should match the adjustment amount                          MD026969A
      *                                                                                    MD026969A
     C                   MOVEL     S#CSSN        W#CNUM                                    MD026969A
     C                   MOVEL     S#FACT        W#FACL                                    MD026969A
     C                   MOVE      S#FCNO        W#FACL                                    MD026969A
     C                   MOVE      S#FSEQ        W#FSEQ                                    MD026969A
     C     S#TYPE        IFEQ      'P'                                                     MD026969A
     C     S#ACTN        ANDNE     'X'                                                     MD026969A
     C     S#ACTN        ANDNE     'D'                                                     MD026969A
     C     W#CPAM        ANDEQ     0                                                       MD026969A
     C     S#SADJok      ANDNE     'N'                                                     MD026969A
     C     K#FZAS        CHAIN(N)  LEFZASL2                                                MD026969A
     C                   IF        %FOUND(LEFZASL2)                                        MD026969A
     C                   IF        P_SIGN = '-'                                             MD054354
     C                   Z-SUB     W#SADJ        WKSADJ                                    MD026969A
     C                   ELSE                                                              MD026969A
     C                   Z-ADD     W#SADJ        WKSADJ                                    MD026969A
     C                   ENDIF                                                             MD026969A
     C                   IF        WKSADJ <> FZAMTP                                        MD026969A
     C                   MOVE      'N'           S#SADJok                                  MD026969A
     C                   ADD       1             Ix                                        MD026969A
     C                   MOVEL     'S#SADJ    '  FldNameArr(Ix)                            MD026969A
     C                   MOVEL     'LER0418'     MsgIdArr(Ix)                              MD026969A
     C                   ENDIF                                                             MD026969A
     C                   ENDIF                                                             MD026969A
     C                   ENDIF                                                             MD026969A
      *                                                                                    MD026969A
     C                   ENDIF                                                              MD054354
      *                                                                                     MD054354
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Type
      *****************************************************************
     C     VLTYPE        BEGSR
 
      * Type must be write off, full or partial settlement
 
     C     S#TYPE        IFNE      'W'
     C     S#TYPE        ANDNE     'F'
     C     S#TYPE        ANDNE     'P'
     C                   MOVE      'N'           S#TYPEok
     C                   ADD       1             Ix
     C                   MOVEL     'S#TYPE    '  FldNameArr(Ix)
     C                   MOVEL     'LER0078'     MsgIdArr(Ix)
     C                   ENDIF
      *                                                                                     MD026969
      ** If W#CPAM is zero, type should be Partial (insert and amend)                       MD026969
      *                                                                                     MD026969
     C     S#TYPE        IFNE      'P'                                                      MD026969
     C     S#ACTN        ANDNE     'X'                                                      MD026969
     C     S#ACTN        ANDNE     'D'                                                      MD026969
     C     W#CPAM        ANDEQ     0                                                        MD026969
     C     S#TYPEok      ANDNE     'N'                                                      MD026969
     C     PDFeeSet      ANDEQ     'Y'                                                      MD054354
     C                   MOVE      'N'           S#TYPEok                                   MD026969
     C                   ADD       1             Ix                                         MD026969
     C                   MOVEL     'S#TYPE    '  FldNameArr(Ix)                             MD026969
     C                   MOVEL     'LER0417'     MsgIdArr(Ix)                               MD026969
     C                   ENDIF                                                              MD026969
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate Settlement Amount & Type
      *****************************************************************
     C     VLSADJTYPE    BEGSR
 
      ** For full settlement, issue a warning message if
      ** not the full fee amount past due is being settled
 
     C                   SELECT
     C     S#TYPE        WHENEQ    'F'
 
     C     W#SADJ        IFNE      W#CPAM
     C                   MOVE      'W'           S#SADJok
     C                   ADD       1             Wx
     C                   MOVEL     'S#SADJ    '  WFldNamArr(Wx)
     C     W#SADJ        IFLT      W#CPAM
     C                   MOVEL     'LER0180'     WMsgIDArr(Wx)
     C                   ELSE
     C                   MOVEL     'LER0181'     WMsgIDArr(Wx)
     C                   ENDIF
     C                   ENDIF
 
      ** For partial settlement, an amount less than the amount
      ** due must be entered
 
     C     S#TYPE        WHENEQ    'P'
 
     C     W#SADJ        IFGE      W#CPAM
     C     PDFeeSet      ANDNE     'Y'                                                      MD054354
     C     W#SADJ        ORGE      W#CPAM                                                   MD054354
     C     W#CPAM        ANDNE     0                                                        MD026969
     C     PDFeeSet      ANDEQ     'Y'                                                      MD054354
     C                   MOVE      'N'           S#SADJok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SADJ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0079'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** For write offs, the amount to be written off
      ** must not be greater than the amount due
 
     C     S#TYPE        WHENEQ    'W'
 
     C     W#SADJ        IFGT      W#CPAM
     C                   MOVE      'N'           S#SADJok
     C                   ADD       1             Ix
     C                   MOVEL     'S#SADJ    '  FldNameArr(Ix)
     C                   MOVEL     'LER0080'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * SETF_IA  : Set fields on insert and amend and delete          *
      *****************************************************************
     C     SETF_IA       BEGSR
 
      ** Record Id
     C                   MOVE      'S'           STRECI
 
      ** Settlement amount
     C                   MOVE      W#SADJ        STSADJ
 
      ** Write off-full-partial amount
     C                   MOVE      S#TYPE        STTYPE
 
      ** Action
     C                   MOVE      S#ACTN        STACTN
 
      ** Branch code - alpha
     C                   MOVE      FcbrBranch    STBRCA
 
      ** Customer number
     C                   MOVEL     S#CSSN        STCNUM
 
      ** Facility
     C                   MOVEL     S#FACT        STFACL
     C                   MOVE      S#FCNO        STFACL
 
      ** Facility sequence number
     C                   MOVE      S#FSEQ        STFSEQ
                                                                                              CLE073
      ** Loan                                                                                 CLE073
     C                   MOVE      S#LOAN        STLOAN                                       CLE073
 
      ** Value date
     C                   MOVE      W#VDAT        STVDAT
 
      ** Settlement settlement due date
     C                   MOVE      W#SADD        STSADD
 
     ** Participant Fee Indicator
     C                   MOVE      W#PTFI        STPTFI
 
      ** Currency code
     C                   MOVE      S#FCCY        STFCCY
      *                                                                                       CAP084
      ** Initialise CLE031 exchange rates:                                                    CAP084
     C     CLE031        IFNE      'Y'                                                        CAP084
     C                   Z-ADD     0             STREXR                                       CAP084
     C                   Z-ADD     0             STPEXR                                       CAP084
     C                   ENDIF                                                                CAP084
 
      ** Settlement Allocation                                                                CLE034
                                                                                              CLE034
     C                   EVAL      STSTAL = S#STAL                                            CLE034
                                                                                              CLE034
      ** PC Transaction Reference
 
     C     P#MODE        IFEQ      'B'
     C     F5TNRF        ANDNE     *BLANK
     C     CLE106        OREQ      'Y'                                                        CLE106
     C     F5TNRF        ANDNE     *BLANK                                                    CSF011A
     C                   MOVE      F5TNRF        STPCRF
     C                   ELSE
     C     S#ACTN        IFEQ      'I'
     C     FcbrMQSM      IFNE      *BLANKS                                                    CAP084
     C                   MOVEL     FcbrMQSM      W#1ST3            3
     C                   ELSE                                                                 CAP084
     C                   MOVEL     FcbrBranch    W#1ST3                                       CAP084
     C                   ENDIF                                                                CAP084
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        STPCRF
     C                   MOVE      '0001'        STPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
     C                   ENDIF
 
      ** PC Originating Branch
 
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5PCOB        STPCOB
     C                   ELSE
     C                   MOVE      *BLANKS       STPCOB
     C                   ENDIF
 
      ** Transact.no of last update
 
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          STTNLU
 
      ** Last swift confirmation seq.
 
     C                   Z-ADD     0             STLSWC
 
      ** Last swift sequence
 
     C                   Z-ADD     0             STLSWS
 
      ** Input, authorise, amend user
 
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5IUSR        STIUSR
     C                   MOVE      F5XUSR        STXUSR
     C                   MOVE      F5AUSR        STAUSR
     C                   ELSE
     C     S#ACTN        IFEQ      'A'
     C                   MOVE      PsUser        STAUSR
     C                   ELSE
     C     S#ACTN        IFEQ      'I'                                                        CAP084
     C                   MOVE      PsUser        STIUSR
     C                   ENDIF                                                                223947
     C     S#ACTN        IFEQ      'X'                                                        CAP084
     C                   MOVE      PsUser        STXUSR
     C                   ENDIF                                                                CAP084
     C***********        ENDIF                                                         CAP084 223947
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD026969
      ** Settlement Amount sign                                                             MD026969
      *                                                                                     MD026969
     C                   IF        PDFeeSet = 'Y'                                           MD054354
     C                   IF        P_SIGN = *BLANK                                          MD054354
     C                   MOVE      '+'           STSIGN                                     MD026969
     C                   MOVE      '+'           P_SIGN                                     MD026969
     C                   ELSE                                                               MD026969
     C                   MOVE      P_SIGN        STSIGN                                     MD054354
     C                   ENDIF                                                              MD026969
     C                   ENDIF                                                              MD054354
 
     C                   ENDSR
      *****************************************************************                       CAP084
      /SPACE 5                                                                                CAP084
      *****************************************************************                       CAP084
      * Save previous values of fields:                                                       CAP084
      *****************************************************************                       CAP084
     C     SAVFLD        BEGSR                                                                CAP084
      *                                                                                       CAP084
      ** Save Settlement instructions as they may have been amended:                          CAP084
     C                   MOVEL     VFEST         SAVFEST                                      CAP084
      *                                                                                       CAP084
      ** Move old version of file into empty new copy of file:                                CAP084
     C                   MOVEL     LEFESTFmt     VFEST                                        CAP084
      *                                                                                       CAP084
      ** Restore saved Settlement instructions:                                               CAP084
                                                                                              CAP084
     C     W#PTFI        IFEQ      *BLANK                                                     CAP084
      ** Receive Settlement details                                                           CAP084
                                                                                              CAP084
     C                   MOVE      SVSTMETH      STMETH                                       CAP084
     C                   MOVE      SVSTOURS      STOURS                                       CAP084
     C                   MOVEL     SVSTTHER      STTHER                                       CAP084
     C                   MOVE      SVSTOSBR      STOSBR                                       CAP084
                                                                                              CAP084
     C                   MOVE      SVSTRSTM      STRSTM                                       CAP084
     C                   MOVE      SVSTRONS      STRONS                                       CAP084
     C                   MOVEL     SVSTRIBN      STRIBN                                       CAP084
     C                   MOVEL     SVSTRIBA      STRIBA                                       CAP084
     C                   MOVE      SVSTROBN      STROBN                                       CAP084
     C                   MOVE      SVSTROCN      STROCN                                       CAP084
     C                   MOVE      SVSTOSDB      STOSDB                                       CAP084
     C                   MOVE      SVSTSCCY      STSCCY                                       CAP084
                                                                                              CAP084
      ** Payment Settlement details                                                           CAP084
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
     C     W#PTFI        IFEQ      'P'                                                        CAP084
     C     W#PTFI        OREQ      'S'                                                        CLE106
     C     W#PTFI        OREQ      'R'                                                        CLE106
                                                                                              CAP084
     C                   MOVE      SVSTMETH      STMETH                                       CAP084
     C                   MOVE      SVSTOURS      STOURS                                       CAP084
     C                   MOVE      SVSTTHER      STTHER                                       CAP084
     C                   MOVE      SVSTOSBR      STOSBR                                       CAP084
      *                                                                                       CAP084
     C                   MOVE      SVSTPSTM      STPSTM                                       CAP084
     C                   MOVE      SVSTPONS      STPONS                                       CAP084
     C                   MOVE      SVSTPIBN      STPIBN                                       CAP084
     C                   MOVE      SVSTPIBA      STPIBA                                       CAP084
     C                   MOVE      SVSTPOBN      STPOBN                                       CAP084
     C                   MOVE      SVSTPOCN      STPOCN                                       CAP084
     C                   MOVE      SVSTRCRN      STRCRN                                       CAP084
     C                   MOVE      SVSTRCRA      STRCRA                                       CAP084
     C                   MOVE      SVSTRVNO      STRVNO                                       CAP084
     C                   MOVEL     SVSTAWBN      STAWBN                                       CAP084
     C                   MOVE      SVSTAWBA      STAWBA                                       CAP084
     C                   MOVEL     SVSTBENN      STBENN                                       CAP084
     C                   MOVE      SVSTBENA      STBENA                                       CAP084
     C                   MOVE      SVSTDTP1      STDTP1                                       CAP084
     C                   MOVE      SVSTDTP2      STDTP2                                       CAP084
     C                   MOVE      SVSTDTP3      STDTP3                                       CAP084
     C                   MOVE      SVSTDTP4      STDTP4                                       CAP084
     C                   MOVE      SVSTDCHG      STDCHG                                       CAP084
     C                   MOVEL     SVSTBTB1      STBTB1                                       CAP084
     C                   MOVEL     SVSTBTB2      STBTB2                                       CAP084
     C                   MOVEL     SVSTBTB3      STBTB3                                       CAP084
     C                   MOVEL     SVSTBTB4      STBTB4                                       CAP084
     C                   MOVEL     SVSTBTB5      STBTB5                                       CAP084
     C                   MOVEL     SVSTBTB6      STBTB6                                       CAP084
     C                   MOVE      SVSTOMDB      STOMDB                                       CAP084
     C                   MOVE      SVSTCVMR      STCVMR                                       CAP084
     C                   MOVE      SVSTSCCY      STSCCY                                       CAP084
     C                   MOVE      SVSTICCY      STICCY                                       CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************
      /SPACE 5
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
     C     ZEDIT         BEGSR
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZTNLU1        BEGSR
 
     C                   CALLB     'ZTNLU1'
     C                   PARM                    RetCodeOut
     C                   PARM                    NATN              5 0
 
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
 
      * Fee Settlement Details in screen format
     C                   PARM                    FEST
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement settlement due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Fee amount past due
     C                   PARM                    W#CPAM           13 0
 
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
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
     C                   PARM                    LEFESTFmt                                    CAP084
     C                   PARM                    P_SIGN            1                        MD054354
      *
      * OUTPUTS
 
      * Status                                                                                CAP084
     C                   PARM                    S#STAT           10                          CAP084
      * Fee Type                                                                              CAP084
     C                   PARM                    S#FTYP           10                          CAP084
      * Fee Code                                                                              CAP084
     C                   PARM                    S#FCOD            2                          CAP084
      * Fee Code description                                                                  CAP084
     C                   PARM                    S#FENV           20                          CAP084
      * Fee Amount Due/Past Due                                                               CAP084
     C                   PARM                    S#DUPD           18                          CAP084
      * Field OK flags
     C                   PARM                    FEST_OK
      * Settlement amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement amount edited
     C                   PARM                    S#SADE           19
 
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
 
      * Valid Fee Settlements
     C                   PARM                    VFEST
 
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
                                                                                              CLE106
      ** If CLE106 is available                                                               CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD             6                          CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
      ** Check for Zero Past Due Fee Settlement system value                                MD054354
     C                   CALLB     'AOSVALR0'                                               MD054354
     C                   PARM      *BLANKS       PRtCd             7                        MD054354
     C                   PARM      PDFeeSttmt    PSysVal01                                  MD054354
     C                   PARM      *BLANKS       PCurSet01                                  MD054354
     C                   PARM      *BLANKS       PSysVal02                                  MD054354
     C                   PARM      *BLANKS       PCurSet02                                  MD054354
     C                   PARM      *BLANKS       PSysVal03                                  MD054354
     C                   PARM      *BLANKS       PCurSet03                                  MD054354
     C                   PARM      *BLANKS       PSysVal04                                  MD054354
     C                   PARM      *BLANKS       PCurSet04                                  MD054354
     C                   PARM      *BLANKS       PSysVal05                                  MD054354
     C                   PARM      *BLANKS       PCurSet05                                  MD054354
     C                   PARM      *BLANKS       PSysVal06                                  MD054354
     C                   PARM      *BLANKS       PCurSet06                                  MD054354
     C                   PARM      *BLANKS       PSysVal07                                  MD054354
     C                   PARM      *BLANKS       PCurSet07                                  MD054354
     C                   PARM      *BLANKS       PSysVal08                                  MD054354
     C                   PARM      *BLANKS       PCurSet08                                  MD054354
     C                   PARM      *BLANKS       PSysVal09                                  MD054354
     C                   PARM      *BLANKS       PCurSet09                                  MD054354
     C                   PARM      *BLANKS       PSysVal10                                  MD054354
     C                   PARM      *BLANKS       PCurSet10                                  MD054354
                                                                                            MD054354
     C                   If        PRtCd <> *Blanks                                         MD054354
     C                   Eval      DBFile = 'SDSVALPD'                                      MD054354
     C                   Eval      DBase = 906                                              MD054354
     C                   Eval      DBKey = '*KEY    '                                       MD054354
     C                   ExSR      *PSSR                                                    MD054354
     C                   EndIf                                                              MD054354
     C                   MOVEL     PCurSet01     PDFeeSet          1                        MD054354
      *                                                                                     MD054354
     C     K#FZAS        KLIST                                                             MD026969A
     C                   KFLD                    W#CNUM                                    MD026969A
     C                   KFLD                    W#FACL                                    MD026969A
     C                   KFLD                    W#FSEQ                                    MD026969A
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