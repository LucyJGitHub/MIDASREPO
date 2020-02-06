     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD AML trans. analysis mapping table validtn')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDAMLMVAL - AML Transaction Analysis Mapping Table Validation*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
 
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Deal Type/Subtype File
 
     FSDLOANL1  IF   E           K DISK    INFSR(*PSSR)
      ** Loan Type/Subtype File by Loan type/subtype
 
     FSDLOANL2  IF   E           K DISK    INFSR(*PSSR)
      ** Loan Type/Subtype File by Loan Subtype
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      /EJECT
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
 
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
      ** External data structure for Deal Subtype details
 
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** External DS for Retail Transaction Types
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for Access Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for Access Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
     D PRetCode        S              7A
     D POption         S              7A
     D PRtTrTyp        S              5A
 
      ** Screen fields
     D #1ACTN          S              1A
     D #1TTYP          S              5A
     D #1DTYP          S              2A
     D #1STYP          S              2A
     D #1AMLT          S             25A
 
      ** Ok Flags
     D #1ACTNOk        S              1A
     D #1TTYPOk        S              1A
     D #1DTYPOk        S              1A
     D #1STYPOk        S              1A
     D #1AMLTOk        S              1A
 
     D KfDTyp          S              2A
     D KfSTyp          S              2A
 
     D PMsgId          S                   LIKE(#MsgID)
     D PSTyp           S                   LIKE(#MsgID)
 
      ** Array for Valid Deal Types
     D WDealTab1       S              2A   DIM(50) CTDATA PERRCD(50)
     D WDealTab2       S              2A   DIM(6) CTDATA PERRCD(6)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset variables updated by validation
 
     C                   EXSR      SrResetErr
     C
 
      ** Validate Action
 
     C                   EXSR      SrValACTN
 
     C                   IF        (#1ACTNOk <> 'Y') OR (#1ACTNOk = 'Y') AND
     C                             (#1ACTN = 'D')
     C                   GOTO      EMain
     C                   ENDIF
 
      ** Validate Field Entries
 
     C                   EXSR      SrValFlds
 
     C                   IF        #1TTYPOk <> 'Y' OR #1DTYPOk <> 'Y' OR
     C                             #1STYPOk <> 'Y'
     C                   GOTO      EMain
     C                   ENDIF
 
      ** Validate Midas Retail Transaction Type Code
 
     C                   IF        #1TTYP <> *BLANKS
     C                   EXSR      SrValTTYP
 
     C                   IF        #1TTYPOk <> 'Y'
     C                   GOTO      EMain
     C                   ENDIF
 
     C                   ELSE
 
      ** Validate Deal/Loan Type/Subtype fields and combination
 
     C                   EXSR      SrValDTST
 
     C                   IF        #1DTYPOK <> 'Y' OR #1STYPOK <> 'Y'
     C                   GOTO      EMain
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate AML Transaction Type
 
     C                   EXSR      SrValAMLT
 
     C     EMain         TAG
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValACTN - Validate Action Code                             *
      *                                                               *
      *****************************************************************
     C     SrValACTN     BEGSR
 
     C                   IF        #1ACTN <> *BLANKS AND #1ACTN <> 'D'
      ** Invalid Action Code
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1ACTN'
     C                   EVAL      MsgIDArr(Idx) = 'USR9663'
     C                   EVAL      #1ACTNOk = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValFlds - Validate Entry to Fields                         *
      *                                                               *
      *****************************************************************
     C     SrValFlds     BEGSR
 
     C                   IF        #1TTYP = *BLANKS AND #1DTYP = *BLANKS AND
     C                             #1STYP = *BLANKS OR
     C                             #1TTYP <> *BLANKS AND (#1DTYP <> *BLANKS OR
     C                             #1STYP <> *BLANKS)
      ** Either Retail Transaction Type Code or Deal Type/Subtype must be entered
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1TTYP'
     C                   EVAL      MsgIDArr(Idx) = 'USR9664'
     C                   EVAL      #1TTYPOk = 'N'
     C                   EVAL      #1DTYPOk = 'N'
     C                   EVAL      #1STYPOk = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValTTYP - Validate Retail Transaction Type Code            *
      *                                                               *
      *****************************************************************
     C     SrValTTYP     BEGSR
 
     C                   MOVEL     #1TTYP        PRtTrTyp
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM                    PRtTrTyp
     C     SDRETR        PARM      *BLANKS       DSFDY
 
     C                   IF        PRetCode <> *BLANKS
      ** Invalid Retail Transaction Type
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1TTYP'
     C                   EVAL      MsgIDArr(Idx) = 'USR9665'
     C                   EVAL      #1TTYPOk = 'N'
     C                   ELSE
     C                   EVAL      #1TTYP = PRtTrTyp
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValDTST - Validate Deal/Loan Type/Subtype Fields and       *
      *              the Combination                                  *
      *                                                               *
      *****************************************************************
     C     SrValDTST     BEGSR
 
     C                   SELECT
 
      ** When Deal/Loan Type is blank
     C                   WHEN      #1DTYP = *BLANKS
      ** Deal/Loan Type must be entered
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1DTYP'
     C                   EVAL      MsgIDArr(Idx) = 'USR9666'
     C                   EVAL      #1DTYPOk = 'N'
 
      ** When Deal/Loan Subtype is blank
     C                   WHEN      #1STYP = *BLANKS
      ** Deal/Loan Subtype must be entered
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1STYP'
     C                   EVAL      MsgIDArr(Idx) = 'USR9667'
     C                   EVAL      #1STYPOk = 'N'
 
      ** When Deal/Loan Subtype is equal to '**'
     C                   WHEN      #1STYP = '**'
     C     #1DTYP        LOOKUP    WDealTab1                              12
     C                   IF        *IN12 = *OFF
     C     #1DTYP        LOOKUP    WDealTab2                              14
     C                   IF        *IN14 = *OFF
     C     #1DTYP        CHAIN     SDLOANL1                           13
     C                   IF        *IN13 = *ON
      ** Invalid Deal/Loan Type
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1DTYP'
     C                   EVAL      MsgIDArr(Idx) = 'USR9668'
     C                   EVAL      #1DTYPOk = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** When Deal/Loan Subtype is not blank and not equal to '**'
     C                   WHEN      #1STYP <> '**'
 
      ** Call module that validates deal subtype
     C                   CALLB     'MMVDLSTYPE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       PMsgId
     C                   PARM      #1STYP        PSTyp
     C                   PARM      *BLANKS       SDDLST
 
     C                   IF        RetCodeOut <> *BLANKS
 
      ** If this is not a deal subtype, check if it is a loan subtype
     C     #1STYP        CHAIN     SDLOANL2                           13
     C                   IF        *IN13 = *ON
      ** Invalid Deal/Loan Subtype
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1STYP'
     C                   EVAL      MsgIDArr(Idx) = 'USR9669'
     C                   EVAL      #1STYPOk = 'N'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      #1STYP = PSTyp
     C                   ENDIF
 
      ** Valid Deal/Loan Subtype, check combination
     C                   EVAL      KfDTyp = #1DTYP
     C                   EVAL      KfSTyp = #1STYP
 
     C     KlDTST        CHAIN     FDDTSTL1                           12
     C                   IF        *IN12 = *ON
     C     KlDTST        CHAIN     SDLOANL1                           13
     C                   IF        *IN13 = *ON
      ** Invalid Deal/Loan Type/Subtype Combination
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1DTYP'
     C                   EVAL      MsgIDArr(Idx) = 'USR9670'
     C                   EVAL      #1DTYPOk = 'N'
     C                   EVAL      #1STYPOk = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValAMLT - Validate AML Transaction Type                    *
      *                                                               *
      *****************************************************************
     C     SrValAMLT     BEGSR
 
      ** AML transaction type cannot be blank
 
     C                   IF        #1AMLT = *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1AMLT'
     C                   EVAL      MsgIDArr(Idx) = 'USR9662'
     C                   EVAL      #1AMLTOk = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetErr - Reset Error Information that is Received Back   *
      *              from each Validation Module                      *
      *                                                               *
      *****************************************************************
     C     SrResetErr    BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
 
     C                   EVAL      #1ACTNOk = 'Y'
     C                   EVAL      #1TTYPOk = 'Y'
     C                   EVAL      #1DTYPOk = 'Y'
     C                   EVAL      #1STYPOk = 'Y'
     C                   EVAL      #1AMLTOk = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Screen fields
     C                   PARM                    #1ACTN
     C                   PARM                    #1TTYP
     C                   PARM                    #1DTYP
     C                   PARM                    #1STYP
     C                   PARM                    #1AMLT
 
      ** Ok Flags
     C                   PARM                    #1ACTNOk
     C                   PARM                    #1TTYPOk
     C                   PARM                    #1DTYPOk
     C                   PARM                    #1STYPOk
     C                   PARM                    #1AMLTOk
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
     C                   EVAL      DBPGM = 'SDAMLMVAL'
     C     KlDTST        KLIST
     C                   KFLD                    KfDTyp
     C                   KFLD                    KfSTyp
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
** CPY@   **
(c) Finastra International Limited 2002
** WDealTab1
ITIPTDTICILNCDCLDLC1C2BPBDTBDATACSBSBRTSRATRSCPIPDSIFLFTDPDTLPLTFPFSCXOPOTSWCPCCBIBONTRIROINNXIDILPS
** WDealTab2
RFRPRRRSRXFR
