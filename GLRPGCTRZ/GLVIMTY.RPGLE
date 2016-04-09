     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Item Tran Type/Subtype')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVIMTY    - Validate Journal Batch Entry Item               *
      *               Transaction Type/Subtype                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 08May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 245802             Date 20Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TCA102             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  245802 - Correctly validated the Transaction Type when       *
      *           Management A/Cs Module is on and CEU013 is off.     *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Error message array
     D WMsgArr         S             45    DIM(1) CTDATA PERRCD(1)
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** Externally described DS for Retail Transaction Types
      ** Details
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D/COPY WNCPYSRC,GLH00670
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
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
     C                   Z-ADD     *ZERO         Idx
     C                   MOVEL     *BLANKS       W2COIN            1
      *
     C                   EXSR      SRProc
      *
     C     DDTrtyOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   MOVE      DDTRTY        B2TRTY
     C                   MOVE      DDTSTY        B2TSTY
     C                   MOVEL     W2COIN        B2COIN
     C
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Transaction Type input                      *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** Check if value entered is question mark.
      *
     C     '?'           SCAN      DDTRTY                                 01
      *
      ** Validate Transaction Type.
      *
     C     B2ACTY        IFEQ      'R'
     C                   EXSR      SRVTrty
      *
     C                   ELSE
      *
      ** Account is not retail.
      *
     C/COPY WNCPYSRC,GLH00671
     C                   SELECT
      *
     C     *IN01         WHENEQ    *ON
     C                   MOVE      'N'           DDTrtyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTRTY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0998'     MsgIdXAr(Idx)
      *
     C     DDTRTY        WHENNE    *BLANKS
     C     BGNVST        ANDNE     'Y'
     C     DDTRTY        ORNE      *BLANKS
     C     CEU013        ANDEQ     'Y'
     C                   MOVE      'N'           DDTrtyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTRTY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0061'     MsgIdXAr(Idx)
      *
     C                   ENDSL
      *
     C/COPY WNCPYSRC,GLH00672
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTrty - Validate Transaction Type for a Retail Account     *
      *                                                               *
      *****************************************************************
      *
     C     SRVTrty       BEGSR
      *
     C                   SELECT
      *
      ** Error if no Transaction Type entered.
      *
     C     DDTRTY        WHENEQ    *BLANKS
     C                   MOVE      'N'           DDTrtyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTRTY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0107'     MsgIdXAr(Idx)
      *
      ** Error if Transaction Type entered is '?'.
      *
     C     *IN01         WHENEQ    *ON
     C                   MOVE      'N'           DDTrtyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTRTY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C**********         MOVEL     WMsgArr(1)    MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(WMsgArr(1)))                           MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WMsgArr(1))               MD000091
      *
     C                   OTHER
      *
      ** Otherwise, access Transaction Types file to verify
      ** if record exists.
      *
     C                   MOVEL(P)  DDTRTY        PRTTY
      *
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PRTTY             5
     C     SDRETR        PARM      SDRETR        DSFDY
      *
      ** If not found, check for Management Accounts module.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   EXSR      SRNvst
     C                   ELSE
      *
     C                   MOVEL     A1COIN        W2COIN
      *
      ** Validate if Debit/Credit Indicator of Transaction Type
      ** is the same as the Debit/Credit Indicator of the batch
      ** item.
      *
     C     A1DCIN        IFNE      *BLANK
     C     A1DCIN        ANDNE     B2DCIN
     C                   MOVE      'N'           DDTrtyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTRTY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0157'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNvst - Check for Management Accounts module                *
      *                                                               *
      *****************************************************************
      *
     C     SRNvst        BEGSR
      *
      ** If Management Accounts module is not *ON / or CEU013 is *ON /
      ** or Transaction Subtype, Book Code, Profit Centre are blanks
      ** and Reverse/Void Indicator is not 'Y', error if Transaction
      ** Type is not found.
      *
     C     BGNVST        IFNE      'Y'
     C     CEU013        OREQ      'Y'
     C     BGNVST        OREQ      'Y'                                                        245802
     C     CEU013        ANDNE     'Y'                                                        245802
     C     PRTCD         ANDNE     *BLANKS                                                    245802
     C     DDTSTY        OREQ      *BLANKS
     C     DDBKCD        ANDEQ     *BLANKS
     C     DDPRCN        ANDEQ     *BLANKS
     C     DDRVDI        ANDNE     'Y'
     C                   MOVE      'N'           DDTrtyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTRTY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0059'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Type
     C                   PARM                    DDTRTY            5
      *
      ** Transaction Subtype
     C                   PARM                    DDTSTY           10
      *
      ** Book Code
     C                   PARM                    DDBKCD            2
      *
      ** Profit Centre
     C                   PARM                    DDPRCN            4
      *
      ** Reverse/Void Indicator
     C                   PARM                    DDRVDI            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Management Accounts
     C                   PARM                    BGNVST            1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Transaction Type - OK indicator
     C                   PARM                    DDTrtyOK          1
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
     C/COPY WNCPYSRC,GLH00673
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
** CPY@
(c) Misys International Banking Systems Ltd. 2001
** WMsgArr
Transaction type input is not valid.
