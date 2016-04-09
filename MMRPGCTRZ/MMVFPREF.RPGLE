     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Portfolio Reference')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market ILE Module                              *
      *                                                               *
      *  MMVFPREF - Validate Portfolio Reference                      *
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
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)
 
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
 
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External data structure for Portfolio Details
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** External data structure for Portfolio Management ICD
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for Customer Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D OKPortRef       S              1A
     D BGPFMG          S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
     D*ZZCNUM***       S              6S 0                                                    CSD027
     D ZZCNUM          S              6A                                                      CSD027
     D*KFCNUM***       S              6S 0                                                    CSD027
     D KFCNUM          S              6A                                                      CSD027
     D KFPTFR          S              4A
     D PPortRef        S              4A
     D PCustNum        S              6A
     D WPTFRInd        S              1A
 
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
     C                   EVAL      OKPortRef = 'Y'
     C                   EVAL      WPTFRInd = 'N'
 
      ** Validate only if PM is on otherwise field is not shown
 
     C                   IF        BGPFMG = 'Y'
 
     C                   CALLB     'AOPLCSR0'
     C                   PARM      '        '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      PCustNum      PKEY1
     C     SDPLCS        PARM      SDPLCS        DSSDY
 
      ** If Customer not found it must be blanks
 
     C                   IF        PRTCD <> *BLANKS
 
     C                   IF        PPortRef <> *BLANKS
     C                   EVAL      OKPortRef = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFPTFR'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0572'
     C                   EVAL      MsgDtaArr(Idx) = PPortRef
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WPTFRInd = 'Y'
 
      ** If reference is not blanks, it must be a valid portfolio
 
     C                   IF        PPortRef <> *BLANKS
 
     C                   IF        PPortRef <> FCR997
     C                   MOVE      BBCUST        KFCNUM
     C                   MOVEL     PPortRef      KFPTFR
     C     KPort         CHAIN     PMPORTLL                           21
 
     C                   IF        *IN21 = *ON
     C                   EVAL      OKPortRef = 'N'
     C                   EVAL      FldNameArr(Idx) = 'SFPTFR'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0573'
     C                   EVAL      MsgDtaArr(Idx) = PPortRef
     C                   ENDIF
 
     C                   ENDIF
 
      ** If portfolio reference is blanks, retrieve the first reference for
      ** this customer on PMPORTPD or setup with SDPORTPD
 
     C                   ELSE
 
     C                   MOVE      BBCUST        ZZCNUM
     C     ZZCNUM        CHAIN     PMPORTLL                           21
 
     C                   IF        *IN21 = *ON
     C                   MOVEL     FCR997        PPortRef
     C                   ELSE
     C                   MOVEL     PNPTFR        PPortRef
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
      ** Portfolio Management Indicator
      ** Work Customer Number
      ** Work Portfolio Reference
      ** Portfolio Management ICD
     C                   PARM                    RetCodeIn
     C                   PARM                    BGPFMG
     C                   PARM                    PCustNum
     C                   PARM                    PPortRef
     C                   PARM                    SDPORT
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
      ** Portfolio Reference Work Indicator
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    OKPortRef
     C                   PARM                    WPTFRInd
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PCustNum      PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C     KPort         KLIST
     C                   KFLD                    KFCNUM
     C                   KFLD                    KFPTFR
 
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
