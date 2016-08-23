     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(LEFEEAXX) TOFILE(LEFEEAL0) SHARE(*NO)            *
/*XBIB*  OVRDBF FILE(LEFEEDXX) TOFILE(LEFEEDL1) SHARE(*NO)            *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment update')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFEADUPD -  Fee Adjustment Update                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4110            Date 24Jan05               *
      *                 BUG4478            Date 07Oct04               *
      *                 225387             Date 02Mar04               *
      *                 CGP001             Date 05Dec03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CAP084             Date 28Feb03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  BUG4110- Unable to authorise transaction.                    *
      *  BUG4478 - Do not clear the warning error arrays just         *
      *            prior to the database update.                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  225387 - Authorise Fee Adjustments if BPJFAU is blank. This  *
      *           error was logged on Bugzilla as Bug 1189.           *
      *  CGP001 - New ICD setting for Authorisation of Fee Adjustments*
      *           TimeStamp field on LEFEEAD was zeros.               *
      *           PC Reference field on LEFEEAD was blank.            *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *         - Use 24x7 runday                                     *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Fee adjustments
     FLEFEEAXX  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
 
      ** Fee adjustments trailer
     FLEFEEAZ   UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Lending fees
     FLEFEEDXX  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FE_)
     F                                     USROPN
     F                                     COMMIT
 
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
      ** The following /COPY includes the LE standard declares:
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
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D OVRDBF1         C                   'OVRDBF FILE(LEFEEAXX)-
     D                                       TOFILE(LEFEEAL0) SHARE(*NO)'
     D OVRDBF2         C                   'OVRDBF FILE(LEFEEDXX)-
     D                                       TOFILE(LEFEEDL1) SHARE(*NO)'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Fee Adjustment Details in file format
     D LEFEEAD       E DS                  EXTNAME(LEFEEAD)
 
      ** Valid Fee Settlement Details in file format
     D LEVFEADPD     E DS                  EXTNAME(LEVFEADPD)
     D QQOURS1       E                     EXTFLD(QQOURS)                                     CGL029
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
 
      ** Fee Adjustment Details OK indicator
     D FEAD_OK       E DS                  EXTNAME(LEEFEADPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Customer lending details
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure                                   CLE134
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CLE134
                                                                                              CLE134
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
                                                                                              CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
      ** Java user information                                                                CAP084
 
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CSC011          S              1A   INZ('N')
     D CAP086          S              1A   INZ('N')                                           CAP086
     D WProcDate       S                   LIKE(BJRDNB)                                       CAP084
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D WDealNo         S              6A
 
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
 
      *
      ** Clear output fields
      *
     C                   MOVEL     *ALL'Y'       FEAD_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
                                                                                             BUG4478
      ** Only clear warning error details if not coming from MidasPlus                       BUG4478
                                                                                             BUG4478
     C     USRID         IFEQ      *BLANKS                                                   BUG4478
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
     C                   ENDIF                                                               BUG4478
 
      * Initialise loan number (always 0)                                                     CAP084
     C                   IF        CLE073 = 'N'                                               CLE073
     C**********         Z-ADD     0             ADLOAN                                       CAP084
     C                   MOVEL     *BLANK        ADLOAN                                       CLE148
     C                   ENDIF                                                                CLE073
 
      * Set up the key fields to the fee adjustments file
 
     C                   MOVEL     ADCNUM        K#CNUM
     C                   MOVEL     ADFACL        K#FACL
     C**********         Z-ADD     ADLOAN        K#LOAN                                       CLE148
     C                   MOVEL     ADLOAN        K#LOAN                                       CLE148
     C                   MOVEL     ADFSEQ        K#FSEQ
      * If the user is connected via a browser, the job user name is the data                BUG4110
      * source conection name - the actual user name is stored in ZMUSER                     BUG4110
     C                   IN        ZMUSER                                                    BUG4110
 
     C                   SELECT
 
      **  Write fee adjustment record
      **  ===========================
 
     C     S#ACTN        WHENEQ    'I'
     C                   EXSR      WRITER
 
      **  Amend fee adjustment record
      **  ===========================
 
     C     S#ACTN        WHENEQ    'A'
     C                   EXSR      AMENDR
 
      **  Authorise fee adjustment record
      **  ===============================
 
     C     S#ACTN        WHENEQ    'X'
     C                   EXSR      AUTHOR
 
      **  Delete fee adjustment record
      **  ============================
 
     C     S#ACTN        WHENEQ    'D'
     C                   EXSR      DELETR
      *
     C                   ENDSL
 
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
      ** Setup Fee Adjustment support log
 
     C                   CALLB     'LEFEADLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    S#ACTN
     C                   PARM                    LEVFEADPD
      * Prime Facility currency                                                               222373
      * Prime Facility currency decimal places                                                222373
     C                   PARM                    FccyFCCY                                     222373
     C                   PARM                    FccyNBDP                                     222373
     C                   PARM                    TRANSDTL
 
      ** Write to support database log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'LEFEAD'
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      APUSERID = USRID                                           CAP084
     C                   Else                                                                 CAP084
     C                   EVAL      APUSERID = PSUser
     C                   EndIf                                                                CAP084
     C                   MOVEL     ADFRNT        APFOTRANID
     C                   MOVEL     ADAFRT        APFOASOCID
     C                   MOVEL     ADCNUM        W@ADCNUM          6
     C                   MOVEL     ADFACL        W@ADFACL          5
     C                   MOVEL     ADFSEQ        W@ADFSEQ          2
     C                   MOVEL     ADLOAN        W@ADLOAN          6                          CLE073
     C**********         If        ADLOAN  = 0                                         CLE073 CLE148
     C                   IF        ADLOAN  = *BLANK                                           CLE148
     C                   EVAL      PDealNo = W@ADCNUM + W@ADFACL +
     C                                       W@ADFSEQ
     C                   ELSE                                                                 CLE073
     C                   EVAL      PDealNo = W@ADCNUM + W@ADLOAN +                            CLE073
     C                                       W@ADFSEQ                                         CLE073
     C                   ENDIF                                                                CLE073
     C                   EVAL      PADealNo = *BLANKS
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
 
     C                   ENDIF
 
      ** If error occured,
 
     C                   IF        RetCodeOut <> *BLANKS
 
     C                   EVAL      RetCodeIn = '*ERROR'
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  Update the trailer if no errors
      **  Else report an error
 
     C     Ix            IFEQ      0
     C                   EXSR      UPDTRL
     C                   ELSE
     C     RetCodeIn     IFEQ      *BLANK
     C                   MOVEL     '*ERROR    '  RetCodeIn
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * WRITER   : Write fee adjustment record                        *
      *****************************************************************
     C     WRITER        BEGSR
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   CLEAR                   LEFEEADF
 
      * Record ID
     C                   MOVE      'A'           FARECI
 
      * Adjustment amount
     C                   Z-ADD     W#SADJ        FASADJ
 
      * Sign
     C                   MOVE      ADSIGN        FASIGN
 
      * Action
     C                   MOVE      S#ACTN        FAACTN
 
      * TNLU
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FATNLU
 
      * Branch
     C                   MOVE      FcbrBranch    FABRCA
 
      * Customer, facility type and number
 
     C                   MOVEL     ADCNUM        FACNUM
     C                   MOVEL     ADFACL        FAFACL
     C                   MOVEL     ADLOAN        FALOAN                                       CLE073
 
      * Fee sequence
     C                   MOVE      ADFSEQ        FAFSEQ
 
      * Settlement adjustment due date
     C                   Z-ADD     W#SADD        FASADD
 
      * Fee currency
     C                   MOVE      S#FCCY        FAFCCY
 
      * Status is authorised if CLE002 is not installed or if
      * authorisation of fee settlement/adjustment is not allowed
      * Otherwise, it will just be complete
      * Transactions in batch mode are always authorised
 
     C     CLE002        IFEQ      'N'
     C*****BPFSAU        OREQ      'N'                                                        CGP001
     C*****BPFJAU        OREQ      'N'                                                 CGP001 225387
     C     BPFJAU        ORNE      'Y'                                                        225387
     C     P#MODE        OREQ      'B'
     C     ADAUTH        OREQ      'Y'                                                        CAP086
     C                   MOVE      'A'           SSTS
     C                   ELSE
     C                   MOVE      'C'           SSTS
     C                   ENDIF
                                                                                              CGP001
      * PC reference                                                                          CGP001
     C                   MOVE      ADPCRF        PCRF                                         CGP001
                                                                                              CGP001
      * Time Stamp                                                                            CGP001
     C                   EVAL      STMP  = TimeStamp                                          CGP001
 
      * User
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5IUSR        IUSR
     C                   ELSE
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      IUSR = USRID                                               CAP084
     C                   Else                                                                 CAP084
     C                   MOVE      PsUser        IUSR
     C                   EndIf                                                                CAP084
     C                   ENDIF
 
      * Participant fee indicator
     C     CLE004        IFEQ      'Y'
     C                   MOVE      W#PTFI        PTFI
     C                   ENDIF
 
      * If CLE009 is installed
 
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = ADAUTH                                              CAP086
     C                   ENDIF                                                                CAP086
 
      ** Write to fee settlement/adjustment file
 
     C                   WRITE     LEFEEADF                             80
 
      * If an error occurs on the write, then end
 
     C     *IN80         IFEQ      *ON
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LER0071'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EWRITER
     C                   ENDIF
 
     C     EWRITER       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * AMENDR   : Amend fee adjustment record                        *
      *****************************************************************
     C     AMENDR        BEGSR
 
      * Access the record
 
     C     FEEAK         CHAIN     LEFEEADF                           80
      *
     C     *IN80         IFEQ      *ON
     C     FATNLU        ORNE      H#TNLU
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LER0071'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EAMENDR
     C                   ENDIF
 
      * Adjustment amount
     C                   Z-ADD     W#SADJ        FASADJ
 
      * Sign
     C                   MOVE      ADSIGN        FASIGN
 
      * Action
     C                   MOVE      S#ACTN        FAACTN
 
      * TNLU
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FATNLU
 
      * Status will be authorised if CLE002 is not installed
      * or if authorisation of fee settlement/adjustment is not allowed
      * Otherwise, it could be complete or requring re-authorisation
      * Transactions in batch mode are always authorised
 
     C     CLE002        IFEQ      'N'
     C*****BPFSAU        OREQ      'N'                                                        CGP001
     C     BPFJAU        OREQ      'N'                                                        CGP001
     C     P#MODE        OREQ      'B'
     C     ADAUTH        OREQ      'Y'                                                        CAP086
     C                   MOVE      'A'           SSTS
     C                   ELSE
     C     SSTS          IFEQ      'A'
     C     SSTS          OREQ      'R'
     C                   MOVE      'R'           SSTS
     C                   ELSE
     C                   MOVE      'C'           SSTS
     C                   ENDIF
     C                   ENDIF
 
      * User
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5AUSR        AUSR
     C                   ELSE
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      AUSR = USRID                                               CAP084
     C                   Else                                                                 CAP084
     C                   MOVE      PsUser        AUSR
     C                   EndIf                                                                CAP084
     C                   ENDIF
 
      * PC reference
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5TNRF        PCRF
     C                   ENDIF
 
      * If CLE009 is installed
 
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF
 
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = ADAUTH                                              CAP086
     C                   ENDIF                                                                CAP086
 
      ** Update fee settlement/adjustment file
 
     C                   UPDATE    LEFEEADF
 
     C     EAMENDR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * AUTHOR   : Authorise fee adjustment record                    *
      *****************************************************************
     C     AUTHOR        BEGSR
 
      * Access the record
 
     C     FEEAK         CHAIN     LEFEEADF                           80
      *
     C     *IN80         IFEQ      *ON
     C     FATNLU        ORNE      H#TNLU
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LER0071'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EAUTHOR
     C                   ENDIF
 
      * Action
     C                   MOVE      S#ACTN        FAACTN
 
      * TNLU
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FATNLU
 
      * Status will be authorised
     C                   MOVE      'A'           SSTS
 
      * User
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5XUSR        XUSR
     C                   ELSE
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      XUSR = USRID                                               CAP084
     C                   Else                                                                 CAP084
     C                   MOVE      PsUser        XUSR
     C                   EndIf                                                                CAP084
     C                   ENDIF
 
      * PC reference
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5TNRF        PCRF
     C                   ENDIF
 
      * If CLE009 is installed
 
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF
 
      ** Update fee settlement/adjustment file
 
     C                   UPDATE    LEFEEADF
 
     C     EAUTHOR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * DELETR   : Delete fee adjustment record                       *
      *****************************************************************
     C     DELETR        BEGSR
 
      * Access the record
 
     C     FEEAK         CHAIN     LEFEEADF                           80
      *
     C     *IN80         IFEQ      *ON
     C     FATNLU        ORNE      H#TNLU
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LER0071'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EDELETR
     C                   ENDIF
 
      * Record ID
     C                   MOVE      '*'           FARECI
 
      * Action
     C                   MOVE      S#ACTN        FAACTN
 
      * TNLU
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FATNLU
 
      * Status is authorised
     C                   MOVE      'A'           SSTS
 
      * PC reference
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5TNRF        PCRF
     C                   ENDIF
 
      * If CLE009 is installed
 
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF
 
      ** Update fee settlement/adjustment file
 
     C                   UPDATE    LEFEEADF
 
     C     EDELETR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * UPDTRL   : Update trailer                                     *
      *****************************************************************
     C     UPDTRL        BEGSR
 
      * Update trailer LEFEEAZ
 
     C     1             SETLL     LEFEEAZ
     C                   READ      LEFEEAZ                              8080
 
     C     *IN80         IFEQ      *ON
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'LEFEEAZ '    DBFILE
     C                   MOVEL     '801'         DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SELECT
 
      **  Inserts
     C     S#ACTN        WHENEQ    'I'
      *
     C                   ADD       1             FANINT
     C                   ADD       1             FANORE
 
      **  Amend
     C     S#ACTN        WHENEQ    'A'
 
     C                   ADD       1             FANAMD
 
      **  Delete
     C     S#ACTN        WHENEQ    'D'
 
     C                   ADD       1             FANDEL
 
     C                   ENDSL
 
     C     *IN80         IFEQ      *OFF
     C                   UPDATE    LEFEEAZF
     C                   ELSE
     C                   MOVE      'Z'           FARECI
     C                   WRITE     LEFEEAZF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZTNLU1        BEGSR
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NATN              5 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRSWRI   : Update fees file                                   *
      *****************************************************************
     C     SRSWRI        BEGSR
 
      * Access fee
 
     C     FEEAK         CHAIN     LEFEEDF                            80
 
     C     *IN80         IFEQ      *ON
     C     FE_FERECI     ORNE      'D'
     C                   MOVEL     'LEFEED '     DBFILE
     C                   MOVEL     '800'         DBASE
     C                   MOVEL     '*UPDATE'     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the fee is a confirmed fee
 
     C     FE_FEAUTO     IFEQ      'Y'
     C     FE_FEAUTO     OREQ      'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
 
      * If payment on is blank or start, and start pay/receive telex
      * indicator for fees is 'Y' or payment on is end and end pay/
      * receive telex indicator for fees is 'Y' or payment on is next
      * and next pay/receive telex indicator for fees is 'Y'
 
     C     FE_FEPYON     IFEQ      *BLANKS
     C     FE_FESPTI     ANDEQ     'Y'
     C     FE_FEPYON     OREQ      'S'
     C     FE_FESPTI     ANDEQ     'Y'
     C     FE_FEPYON     OREQ      'E'
     C     FE_FEEPTI     ANDEQ     'Y'
     C     FE_FEPYON     OREQ      'N'
     C     FE_FEPPTI     ANDEQ     'Y'
 
      * If swift message regeneration indicator for fees is not 'I'
      * and not 'B' and not 'H'
 
     C     FE_FESWRI     IFNE      'I'
     C     FE_FESWRI     ANDNE     'B'
     C     FE_FESWRI     ANDNE     'H'
      *
     C                   MOVE      *BLANKS       CHGIND            1
 
      * If authorisations switchable feature is off,or authorisations
      * switchable feature is on and fee settlements authorisations
      * is not required
 
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C*****BPFSAU        ANDEQ     'N'                                                        CGP001
     C     BPFJAU        ANDEQ     'N'                                                        CGP001
 
      * If action code is insert or amend
 
     C     S#ACTN        IFEQ      'I'
     C     S#ACTN        OREQ      'A'
     C                   MOVE      'Y'           CHGIND
     C                   ENDIF
      *
     C                   ELSE
 
      * If action code is authorise
 
     C     S#ACTN        IFEQ      'X'
     C                   MOVE      'Y'           CHGIND
     C                   ENDIF
      *
     C                   ENDIF
 
      * If action code is delete
 
     C     S#ACTN        IFEQ      'D'
     C                   MOVE      'Y'           CHGIND
     C                   ENDIF
 
      * Update fees file
 
     C     CHGIND        IFEQ      'Y'
     C                   MOVE      'A'           FE_FELCHT
     C******             Z-ADD     BJRDNB        FE_FELCHD                                    CAP084
     C                   Z-ADD     WProcDate     FE_FELCHD                                    CAP084
     C                   MOVE      'A'           FE_FESWRI
     C                   UPDATE    LEFEEDF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
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
 
      * Action Code
     C                   PARM                    S#ACTN            1
 
      * Fee Adjustment Details in file format
     C                   PARM                    LEVFEADPD
 
      * Fee currency
     C                   PARM                    S#FCCY            3
 
      * Adjustment amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * TNLU of fee adjustment record on LEFEEAD
     C                   PARM                    H#TNLU            5 0
 
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
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
      *
      * OUTPUTS
      *
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
 
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CLE083 - Calculation of loan based fees is installed                        CLE073
                                                                                              CLE073
     C                   CALL      'AOSARDR0'                                                 CLE073
     C                   PARM      *BLANKS       @RTCD                                        CLE073
     C                   PARM      '*KEY    '    @OPTN                                        CLE073
     C                   PARM      'CLE073'      @SARD             6                          CLE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE073
                                                                                              CLE073
     C     @RTCD         IFEQ      *BLANKS                                                    CLE073
     C                   MOVEL     'Y'           CLE073                                       CLE073
     C                   ELSE                                                                 CLE073
     C                   MOVEL     'N'           CLE073            1                          CLE073
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
      *                                                                                       CLE134
      ** Past Due Call Loan  - CLE134                                                         CLE134
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*KEY    '    @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD             6                          CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVEL     'Y'           CLE134                                       CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVEL     'N'           CLE134            1                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Check if CLE002 - Lending Authorisations - is Installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE002
     C                   ELSE
     C                   MOVEL     'N'           CLE002            1
     C                   ENDIF
 
      ** Retrieve customer lending data, if CLE002 is Installed
 
     C     CLE002        IFEQ      'Y'
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CLE004 - Customer Lending Syndications - is Installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'CLE004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE004
     C                   ELSE
     C                   MOVEL     'N'           CLE004            1
     C                   ENDIF
 
      ** Check if CLE009 - Customer Lending Enhancements - is Installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009            1
     C                   ELSE
     C                   MOVE      'N'           CLE009
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'LEFEADUPD'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 906                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
 
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*the*data          CAP084BUG4110
      **source*conection*name*-*the*actual*user*name*is*stored*in*ZMUSER               CAP084BUG4110
     C*******************IN********ZMUSER                                              CAP084BUG4110
                                                                                              CAP084
      ** If 24X7 Midas availability is installed and support system is                        CAP084
      ** active, used processing date from dataarea SC24X7 as the                             CAP084
      ** rundate.                                                                             CAP084
                                                                                              CAP084
     C                   IF        CSC011 = 'Y' AND                                           CAP084
     C                             S1SUPP = LIBR                                              CAP084
     C                   EVAL      WProcDate = S1DATE                                         CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      WProcDate = BJRDNB                                         CAP084
     C                   ENDIF                                                                CAP084
 
     C     *LIKE         DEFINE    FACNUM        K#CNUM
     C     *LIKE         DEFINE    FAFACL        K#FACL
     C     *LIKE         DEFINE    FALOAN        K#LOAN
     C     *LIKE         DEFINE    FAFSEQ        K#FSEQ
 
      * Key lists
 
     C     FEEAK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
 
      ** OVRDBF LEFEEAL0 to LEFEEAXX then OPEN LEFEEAXX
 
     C                   EVAL      LENGTH = %SIZE(OVRDBF1)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF1       QCMD             70
     C                   PARM                    LENGTH           15 5
     C                   OPEN      LEFEEAXX
 
      ** OVRDBF LEFEEDL2 to LEFEEDXX then OPEN LEFEEDXX
 
     C                   EVAL      LENGTH = %SIZE(OVRDBF2)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF2       QCMD             70
     C                   PARM                    LENGTH           15 5
     C                   OPEN      LEFEEDXX
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
(c) Misys International Banking Systems Ltd. 2002
