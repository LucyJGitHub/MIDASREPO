     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details Message Validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDCUSD3VL - Customer Message Details Validation             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD040876           Date 13Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT050             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 09Apr99               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT050 - SWIFTRef Directories upload (Recompile)             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87 (Recompiled).       *
      *  CSD007 - Customer Closing: Recompile.                        *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDMV001
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      **
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
 
      ** Primary Details in screen format
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
 
      ** Secondary Details in screen format
     D CuSeco        E DS                  EXTNAME(SDCUSEPD)
 
      ** Message Details in screen format
     D CuMsg         E DS                  EXTNAME(SDCUMRPD)
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
      ** Messages OK indicators
     D OKCuMsg       E DS                  EXTNAME(SDECUMRPD)
 
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)
      * Valid Customer Details Layout
 
     D ExtData       E DS                  EXTNAME(SDCUEXPD)
      * SD Messages Extra Data - File (D/B) format
 
     D DDDSXX          S                   LIKE(DDDS01)
      * Default Status Rel.XX
 
     D DDDNWX          S                   LIKE(DDDNW1)
      * Default Network (MTXnn)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUDMV002
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCUDMV003
 
 
      ** Pass data not requiring validation to VALIDCUSD fields
      *
      ** Msg Type not Gen.01 - Mst Type not Gen.15
     C                   MOVE      DDNG01        CUNG01
     C                   MOVE      DDNG02        CUNG02
     C                   MOVE      DDNG03        CUNG03
     C                   MOVE      DDNG04        CUNG04
     C                   MOVE      DDNG05        CUNG05
     C                   MOVE      DDNG06        CUNG06
     C                   MOVE      DDNG07        CUNG07
     C                   MOVE      DDNG08        CUNG08
     C                   MOVE      DDNG09        CUNG09
     C                   MOVE      DDNG10        CUNG10
     C                   MOVE      DDNG11        CUNG11
     C                   MOVE      DDNG12        CUNG12
     C                   MOVE      DDNG13        CUNG13
     C                   MOVE      DDNG14        CUNG14
     C                   MOVE      DDNG15        CUNG15
      *
      *
      * Call Validation Modules in Sequence
      *
      ** Validate Default Status Rel.01
      *
      /COPY WNCPYSRC,SDCUDMV004
     C                   EVAL      DDDSXX = DDDS01
     C                   EVAL      FieldName = 'DDDS01    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS01 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV005
      *
      *
      ** Validate Default Status Rel.02
      *
      /COPY WNCPYSRC,SDCUDMV006
     C                   EVAL      DDDSXX = DDDS02
     C                   EVAL      FieldName = 'DDDS02    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS02 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV007
      *
      *
      ** Validate Default Status Rel.03
      *
      /COPY WNCPYSRC,SDCUDMV008
     C                   EVAL      DDDSXX = DDDS03
     C                   EVAL      FieldName = 'DDDS03    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS03 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV009
      *
      *
      ** Validate Default Status Rel.04
      *
      /COPY WNCPYSRC,SDCUDMV010
     C                   EVAL      DDDSXX = DDDS04
     C                   EVAL      FieldName = 'DDDS04    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS04 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV011
      *
      *
      ** Validate Default Status Rel.05
      *
      /COPY WNCPYSRC,SDCUDMV012
     C                   EVAL      DDDSXX = DDDS05
     C                   EVAL      FieldName = 'DDDS05    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS05 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV013
      *
      *
      ** Validate Default Status Rel.06
      *
      /COPY WNCPYSRC,SDCUDMV014
     C                   EVAL      DDDSXX = DDDS06
     C                   EVAL      FieldName = 'DDDS06    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS06 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV015
      *
      *
      ** Validate Default Status Rel.07
      *
      /COPY WNCPYSRC,SDCUDMV016
     C                   EVAL      DDDSXX = DDDS07
     C                   EVAL      FieldName = 'DDDS07    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS07 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV017
      *
      *
      ** Validate Default Status Rel.08
      *
      /COPY WNCPYSRC,SDCUDMV018
     C                   EVAL      DDDSXX = DDDS08
     C                   EVAL      FieldName = 'DDDS08    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS08 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV019
      *
      *
      ** Validate Default Status Rel.09
      *
      /COPY WNCPYSRC,SDCUDMV020
     C                   EVAL      DDDSXX = DDDS09
     C                   EVAL      FieldName = 'DDDS09    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS09 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV021
      *
      *
      ** Validate Default Status Rel.10
      *
      /COPY WNCPYSRC,SDCUDMV022
     C                   EVAL      DDDSXX = DDDS10
     C                   EVAL      FieldName = 'DDDS10    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS10 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV023
      *
      *
      ** Validate Default Status Rel.11
      *
      /COPY WNCPYSRC,SDCUDMV024
     C                   EVAL      DDDSXX = DDDS11
     C                   EVAL      FieldName = 'DDDS11    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS11 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV025
      *
      *
      ** Validate Default Status Rel.12
      *
      /COPY WNCPYSRC,SDCUDMV026
     C                   EVAL      DDDSXX = DDDS12
     C                   EVAL      FieldName = 'DDDS12    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS12 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV027
      *
      *
      ** Validate Default Status Rel.13
      *
      /COPY WNCPYSRC,SDCUDMV028
     C                   EVAL      DDDSXX = DDDS13
     C                   EVAL      FieldName = 'DDDS13    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS13 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV029
      *
      *
      ** Validate Default Status Rel.14
      *
      /COPY WNCPYSRC,SDCUDMV030
     C                   EVAL      DDDSXX = DDDS14
     C                   EVAL      FieldName = 'DDDS14    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS14 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV031
      *
      *
      ** Validate Default Status Rel.15
      *
      /COPY WNCPYSRC,SDCUDMV032
     C                   EVAL      DDDSXX = DDDS15
     C                   EVAL      FieldName = 'DDDS15    '
     C                   EVAL      DDDSXXOK = 'Y'
     C                   EXSR      VCDSXX
     C                   EVAL      CUDS15 = DDDSXX
      /COPY WNCPYSRC,SDCUDMV033
      *
      *
      ** Validate Default Network Details 1
      *
      /COPY WNCPYSRC,SDCUDMV034
     C                   EVAL      DDDNWX = DDDNW1
     C                   EVAL      FieldName = 'DDDNW1    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW1 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV035
      *
      *
      ** Validate Default Network Details 2
      *
      /COPY WNCPYSRC,SDCUDMV036
     C                   EVAL      DDDNWX = DDDNW2
     C                   EVAL      FieldName = 'DDDNW2    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW2 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV037
      *
      *
      ** Validate Default Network Details 3
      *
      /COPY WNCPYSRC,SDCUDMV038
     C                   EVAL      DDDNWX = DDDNW3
     C                   EVAL      FieldName = 'DDDNW3    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW3 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV039
      *
      *
      ** Validate Default Network Details 4
      *
      /COPY WNCPYSRC,SDCUDMV040
     C                   EVAL      DDDNWX = DDDNW4
     C                   EVAL      FieldName = 'DDDNW4    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW4 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV041
      *
      *
      ** Validate Default Network Details 5
      *
      /COPY WNCPYSRC,SDCUDMV042
     C                   EVAL      DDDNWX = DDDNW5
     C                   EVAL      FieldName = 'DDDNW5    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW5 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV043
      *
      *
      ** Validate Default Network Details 6
      *
      /COPY WNCPYSRC,SDCUDMV044
     C                   EVAL      DDDNWX = DDDNW6
     C                   EVAL      FieldName = 'DDDNW6    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW6 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV045
      *
      *
      ** Validate Default Network Details 7
      *
      /COPY WNCPYSRC,SDCUDMV046
     C                   EVAL      DDDNWX = DDDNW7
     C                   EVAL      FieldName = 'DDDNW7    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW7 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV047
      *
      *
      ** Validate Default Network Details 8
      *
      /COPY WNCPYSRC,SDCUDMV048
     C                   EVAL      DDDNWX = DDDNW8
     C                   EVAL      FieldName = 'DDDNW8    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW8 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV049
      *
      *
      ** Validate Default Network Details 9
      *
      /COPY WNCPYSRC,SDCUDMV050
     C                   EVAL      DDDNWX = DDDNW9
     C                   EVAL      FieldName = 'DDDNW9    '
     C                   EVAL      DDDNWXOK = 'Y'
     C                   EXSR      VCDNWX
     C                   EVAL      CUDNW9 = DDDNWX
      /COPY WNCPYSRC,SDCUDMV051
      *
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUDMV052
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Message Type Description - DDDS01...DDDS15
      *****************************************************************
      *
     C     VCDSXX        BEGSR
      *
      * Reset variables updated by each module
     C                   EXSR      RESETERRS
      *
      ** Validate Default Status Rel.
     C                   CALLB     'SDVSSDE'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default Status Rel.
     C                   PARM                    DDDSXX
      *
      ** Default Status field name
     C                   PARM                    FieldName        10
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Default Status Rel.      - OK
     C                   PARM                    DDDSXXOK          1
     C                   IF        DDDSXXOK = 'N'
     C                   SELECT
     C                   WHEN      FieldName = 'DDDS01'
     C                   EVAL      DDDS01OK = 'N'
     C                   WHEN      FieldName = 'DDDS02'
     C                   EVAL      DDDS02OK = 'N'
     C                   WHEN      FieldName = 'DDDS03'
     C                   EVAL      DDDS03OK = 'N'
     C                   WHEN      FieldName = 'DDDS04'
     C                   EVAL      DDDS04OK = 'N'
     C                   WHEN      FieldName = 'DDDS05'
     C                   EVAL      DDDS05OK = 'N'
     C                   WHEN      FieldName = 'DDDS06'
     C                   EVAL      DDDS06OK = 'N'
     C                   WHEN      FieldName = 'DDDS07'
     C                   EVAL      DDDS07OK = 'N'
     C                   WHEN      FieldName = 'DDDS08'
     C                   EVAL      DDDS08OK = 'N'
     C                   WHEN      FieldName = 'DDDS09'
     C                   EVAL      DDDS09OK = 'N'
     C                   WHEN      FieldName = 'DDDS10'
     C                   EVAL      DDDS10OK = 'N'
     C                   WHEN      FieldName = 'DDDS11'
     C                   EVAL      DDDS11OK = 'N'
     C                   WHEN      FieldName = 'DDDS12'
     C                   EVAL      DDDS12OK = 'N'
     C                   WHEN      FieldName = 'DDDS13'
     C                   EVAL      DDDS13OK = 'N'
     C                   WHEN      FieldName = 'DDDS14'
     C                   EVAL      DDDS14OK = 'N'
     C                   WHEN      FieldName = 'DDDS15'
     C                   EVAL      DDDS15OK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Default Network - DDDNW1...DDDNW9
      *****************************************************************
      *
     C     VCDNWX        BEGSR
      *
      * Reset variables updated by each module
     C                   EXSR      RESETERRS
      *
      ** Validate Default Network
     C                   CALLB     'SDVNWDE'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default Network
     C                   PARM                    DDDNWX
      *
      ** Default Network field name
     C                   PARM                    FieldName
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Default Network - OK
     C                   PARM                    DDDNWXOK          1
     C                   IF        DDDNWXOK = 'N'
     C                   SELECT
     C                   WHEN      FieldName = 'DDDNW1'
     C                   EVAL      DDDNW1OK = 'N'
     C                   WHEN      FieldName = 'DDDNW2'
     C                   EVAL      DDDNW2OK = 'N'
     C                   WHEN      FieldName = 'DDDNW3'
     C                   EVAL      DDDNW3OK = 'N'
     C                   WHEN      FieldName = 'DDDNW4'
     C                   EVAL      DDDNW4OK = 'N'
     C                   WHEN      FieldName = 'DDDNW5'
     C                   EVAL      DDDNW5OK = 'N'
     C                   WHEN      FieldName = 'DDDNW6'
     C                   EVAL      DDDNW6OK = 'N'
     C                   WHEN      FieldName = 'DDDNW7'
     C                   EVAL      DDDNW7OK = 'N'
     C                   WHEN      FieldName = 'DDDNW8'
     C                   EVAL      DDDNW8OK = 'N'
     C                   WHEN      FieldName = 'DDDNW9'
     C                   EVAL      DDDNW9OK = 'N'
     C                   ENDSL
     C                   ENDIF
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Customer Primary Details
      ** Customer Secondary Details
      ** Customer Message Details
      ** Customer Extra Data
     C                   PARM                    CuPrim
     C                   PARM                    CuSeco
     C                   PARM                    CuMsg
     C                   PARM                    ExtData
      *
      * OUTPUTS
      *
      ** Customer Message Detail OK inds
     C                   PARM                    OKCuMsg
 
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Customer Details Layout (DS) from/to caller
     C                   PARM                    ValidCusd
      *
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUDMV053
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDCUSD4VL'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
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
**  CPY@
(c) Finastra International Limited 2001
