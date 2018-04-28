     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Customer Number')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market ILE Module                              *
      *                                                               *
      *  MMVFCUST - Validate Customer Number                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905   *CREATE   Date 25Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  209905 - Fiduciary API Enhancement                           *
      *                                                               *
      *****************************************************************
 
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
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D OKCustNum       S              1A
     D PDType          S              2A
     D PCustNum        S              6A
     D PDealType       S              2A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
     D*PCustNo**       S              6S 0                                                    CSD027
     D PCustNo         S              6A                                                      CSD027
     D PReturnCode     S              7A
     D PErrMsgID1      S              7A
     D PErrMsgID2      S              7A
     D PWMsgID1        S              7A
 
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
     C                   EVAL      OKCustNum = 'Y'
 
      ** Must be a valid Customer Number
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PCustNum      PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      OKCustNum = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFCNUM'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0571'
     C                   EVAL      MsgDtaArr(Idx) = PCustNum
     C                   ELSE
 
      ** Validate Customer
 
     C                   SELECT
     C                   WHEN      PDType = 'FL'
     C                   MOVE      'FT'          PDealType
     C                   WHEN      PDType = 'DP'
     C                   MOVE      'DT'          PDealType
     C                   WHEN      PDType = 'LP'
     C                   MOVE      'LT'          PDealType
     C                   ENDSL
 
     C                   MOVE      BBCUST        PCustNo
 
     C                   CALLB     'MMVCUSTFID'
     C                   PARM                    PDealType
     C                   PARM                    PCustNo
     C                   PARM                    SDCUST
     C                   PARM                    PReturnCode
     C                   PARM                    PErrMsgID1
     C                   PARM                    PErrMsgID2
     C                   PARM                    PWMsgID1
 
     C                   IF        PReturnCode <> *BLANKS
     C                   EVAL      OKCustNum = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFCNUM'
     C                   IF        PErrMsgID1 <> *BLANKS
     C                   EVAL      MsgIDArr(Idx) = PErrMsgID1
     C                   ELSE
     C                   EVAL      MsgIDArr(Idx) = PErrMsgID2
     C                   ENDIF
     C                   EVAL      MsgDtaArr(Idx) = PCustNum
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
      ** Deal Type
      ** Work Customer Number
     C                   PARM                    RetCodeIn
     C                   PARM                    PDType
     C                   PARM                    PCustNum
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    OKCustNum
 
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
