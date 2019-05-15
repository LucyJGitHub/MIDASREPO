     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Account Code Sequence')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market ILE Module                              *
      *                                                               *
      *  MMVFACSQ - Validate Account Code Sequence                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905  *CREATE    Date 25Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209905 - Fiduciary API Enhancement                           *
      *                                                               *
      *****************************************************************
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for Customer Details
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** External data structure for Portfolio Management ICD
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D OKAcctSeq       S              1A
     D PCustNum        S              6A
     D***PAcctCode       S              4A                                                    CGL029
     D PAcctCode       S             10A                                                      CGL029
     D PAcctSeq        S              2A
     D PCurrency       S              3A
     D PBranch         S              3A
     D PPortRef        S              4A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
     D*KFCNUM***       S              6S 0                                                    CSD027
     D KFCNUM          S              6A                                                      CSD027
     D***KFACOD*         S              4S 0                                                  CGL029
     D KFACOD          S             10S 0                                                    CGL029
     D KFACSQ          S              2S 0
     D ZFIELD          S             16A
     D ZALIGNOK        S              1A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D WWPTFR          S              4A
     D WPTFRInd        S              1A
     D BGPFMG          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      Idx = 1
     C                   EVAL      OKAcctSeq = 'Y'
 
      ** If blanks, default to account code on SDCUSTPD else must be a
      ** live account
 
     C                   IF        PAcctSeq = *BLANKS
 
     C                   IF        BBDFAS <> 0
     C                   MOVE      BBDFAS        PAcctSeq
     C                   ENDIF
 
      ** Must be a live account
 
     C                   MOVE      BBCUST        KFCNUM
     C                   MOVE      PAcctCode     KFACOD
     C                   MOVE      PAcctSeq      KFACSQ
 
     C     KFAcct        CHAIN     ACCNT                              21
 
     C                   IF        *IN21 = *ON or RECI = 'C'
     C                   EVAL      OKAcctSeq = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFACSQ'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0577'
     C                   EVAL      MsgDtaArr(Idx) = PAcctSeq
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM      PAcctSeq      ZFIELD
     C                   PARM      *ZEROS        ZADEC
     C                   PARM      2             ZADIG
 
     C                   IF        ZALIGNOK = 'N'
     C                   EVAL      OKAcctSeq = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFACSQ'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0576'
     C                   EVAL      MsgDtaArr(Idx) = PAcctSeq
     C                   ELSE
 
      ** Must be a live account
 
     C                   MOVE      BBCUST        KFCNUM
     C                   MOVE      PAcctCode     KFACOD
     C                   MOVE      PAcctSeq      KFACSQ
 
     C     KFAcct        CHAIN     ACCNT                              21
     C                   IF        *IN21 = *ON or RECI = 'C'
     C                   EVAL      OKAcctSeq = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFACSQ'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0577'
     C                   EVAL      MsgDtaArr(Idx) = PAcctSeq
     C                   ELSE
 
      ** PM must be on and Customer must be a portfolio customer
 
     C                   IF        PTFR = '9997'
     C                   MOVE      FCR997        WWPTFR
     C                   ELSE
     C                   MOVE      PTFR          WWPTFR
     C                   ENDIF
 
     C                   IF        BGPFMG = 'Y' and WPTFRInd = 'Y' and
     C                             WWPTFR <> PPortRef
     C                   EVAL      OKAcctSeq = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFACSQ'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0578'
     C                   EVAL      MsgDtaArr(Idx) = PAcctSeq
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** INPUTS
      ** Return Code
      ** Work Customer Number
      ** Work Account Code
      ** Work Account Code Sequence
      ** Currency
      ** Branch
      ** Work Portfolio Reference
      ** Portfolio Management ICD
      ** Portfolio Management Indicator
      ** Portfolio Reference Work Indicator
     C                   PARM                    RetCodeIn
     C                   PARM                    PCustNum
     C                   PARM                    PAcctCode
     C                   PARM                    PAcctSeq
     C                   PARM                    PCurrency
     C                   PARM                    PBranch
     C                   PARM                    PPortRef
     C                   PARM                    SDPORT
     C                   PARM                    BGPFMG
     C                   PARM                    WPTFRInd
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    OKAcctSeq
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PCustNum      PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C     KFAcct        KLIST
     C                   KFld                    KFCNUM
     C                   KFld                    PCurrency
     C                   KFld                    KFACOD
     C                   KFld                    KFACSQ
     C                   KFld                    PBranch
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
