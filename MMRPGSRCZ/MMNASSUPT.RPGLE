     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Sold TM Database Update')
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMNASSUPT - NAS SOLD TM DATABASE UPDATE                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CDL049             Date 11Jul06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  DEALS FILE - NAS SOLD
     D MMDENS        E DS                  EXTNAME(MMDENSPP)
     D  @HMVDY                50     57  0
     D  @HMNIY               152    159  0
     D  @HMSLY               188    195  0
     D  @HMMDY               208    215  0
     D  @DENS1                 1    246
     D  @DENS2               247    313
     D  @DENS3               314    553
     D  @DENS4               554    801
     D  @DENS5               802    941
     D  @DENS6               942    952
     D  @DENS7               953    956
     D  @DENS1Ex            1055   1072                                                       CGL029
     D  @DENS2Ex            1073   1090                                                       CGL029
     D  @DENS3Ex            1091   1126                                                       CGL029
      *
      **  DEALS FILE - NAS PURCHASED
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D QQDOR1        E                     EXTFLD(DORIQQ)                                     CGL029
     D QQMOR1        E                     EXTFLD(MORIQQ)                                     CGL029
     D QQRON1        E                     EXTFLD(RONSQQ)                                     CGL029
     D QQPON1        E                     EXTFLD(PONSQQ)                                     CGL029
     D  @HLVDY                50     57  0
     D  @HLNIY               179    186  0
     D  @HLSLY               223    230  0
     D  @HLMDY               265    272  0
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR LOANS & DEPOSITS
     D MMSTDL        E DS                  EXTNAME(MMSTDLPP)
     D QQDOR2        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR2        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP2        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP2        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON2        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON2        E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR NA BOUGHT FORMAT
     D MMSTDB        E DS                  EXTNAME(MMSTDBPP)
     D QQDOR3        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR3        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP3        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP3        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQBOR3        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP3        E                     EXTFLD(QQBOPI)                                     CGL029
     D QQRON3        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON3        E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR NA SOLD FORMAT
     D MMSTDS        E DS                  EXTNAME(MMSTDSPP)
     D QQDOR4        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR4        E                     EXTFLD(QQMORI)                                     CGL029
     D QQBOR4        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP4        E                     EXTFLD(QQBOPI)                                     CGL029
     D QQROR4        E                     EXTFLD(QQRORI)                                     CGL029
     D QQROP4        E                     EXTFLD(QQROPI)                                     CGL029
     D QQRON4        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON4        E                     EXTFLD(QQPONS)                                     CGL029
     D  @STDS1                 1    246
     D  @STDS2               247    313
     D  @STDS3               708    947
     D  @STDS4               948   1195
     D  @STDS5              1196   1335
     D  @STDS6              1339   1349
     D  @STDS7              1356   1359
     D  @STDS1Ex            1366   1383                                                       CGL029
     D  @STDS2Ex            1384   1401                                                       CGL029
     D  @STDS3Ex            1474   1509                                                       CGL029
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL AMENDMENTS
     D MMSTDA        E DS                  EXTNAME(MMSTDAPP)
     D QQDOR5        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR5        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP5        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP5        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQBOR5        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP5        E                     EXTFLD(QQBOPI)                                     CGL029
     D QQROR5        E                     EXTFLD(QQRORI)                                     CGL029
     D QQROP5        E                     EXTFLD(QQROPI)                                     CGL029
     D QQRON5        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON5        E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *
      * SET STANDARD DEALS FILE
      *
     C                   EXSR      SETSTD
      *
      ** CALL MM0075 - FORWARD BOOK UPDATE
     C                   RESET                   @TERM
 
      ** Reset the U7 and U8 indicators to prevent problems caused by them
      ** being left on from earlier errors.
     C                   CLEAR                   *inu7
     C                   CLEAR                   *inu8
      *
     C                   CALL      'MM0075'
     C                   PARM                    @TERM             1
     C                   PARM      'S'           @ENQ              1
     C                   PARM                    MMSTDL
     C                   PARM                    MMSTDB
     C                   PARM                    MMSTDS
     C                   PARM                    MMSTDA
      *
      ** ERROR
      *
     C     @TERM         IFEQ      'E'
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   RETURN
     C                   END
      *
      ** CALL MM0073 - NEAR DATES SUMMARY UPDATE
     C                   RESET                   @TERM
      *
     C                   CALL      'MM0073'
     C                   PARM                    @TERM
     C                   PARM      'S'           @ENQ
     C                   PARM                    MMSTDL
     C                   PARM                    MMSTDB
     C                   PARM                    MMSTDS
     C                   PARM                    MMSTDA
      *
      ** ERROR
      *
     C     @TERM         IFEQ      'E'
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   RETURN
     C                   END
      *
      ** CALL MM0094 - LIQUIDITY EXPOSURE UPDATE
     C                   RESET                   @TERM
      *
     C                   CALL      'MM0094'
     C                   PARM                    @TERM
     C                   PARM      'S'           @ENQ
     C                   PARM                    MMSTDL
     C                   PARM                    MMSTDB
     C                   PARM                    MMSTDS
     C                   PARM                    MMSTDA
      *
      ** ERROR
      *
     C     @TERM         IFEQ      'E'
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   RETURN
     C                   END
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETSTD - SET STANDARD DEALS FILE                              *
     C*                                                               *
     C*****************************************************************
     C     SETSTD        BEGSR
      *
      * CLEAR STANDARD DEAL FILES
      *
     C                   CLEAR                   MMSTDL
     C                   CLEAR                   MMSTDB
     C                   CLEAR                   MMSTDS
     C                   CLEAR                   MMSTDA
      *
      * GET THE 'AFTER' STATUS OF THE DEAL
      *
     C                   MOVEL     Z#ASTS        MMDENS
      *
      * MOVE DEAL TO STANDARD DEAL
      *
     C                   MOVEL     @DENS1        @STDS1
     C                   MOVEL     @DENS2        @STDS2
     C                   MOVEL     @DENS3        @STDS3
     C                   MOVEL     @DENS4        @STDS4
     C                   MOVEL     @DENS5        @STDS5
     C                   MOVEL     @DENS6        @STDS6
     C                   MOVEL     @DENS7        @STDS7
     C                   MOVEL     @DENS1Ex      @STDS1Ex                                     CGL029
     C                   MOVEL     @DENS2Ex      @STDS2Ex                                     CGL029
     C                   MOVEL     @DENS3Ex      @STDS3Ex                                     CGL029
     C                   MOVEL     HMBOKC        ILBOKC
      *
      * GET THE RELATED DEAL DETAILS
      *
     C                   MOVEL     Z#WSTS        ##RCID            2
      *
      * IF PRESENT
      * SET 'RELATED DEAL' FIELDS ON THE STANDARD DEAL
      *
     C     ##RCID        IFNE      *BLANK
     C                   MOVEL     Z#WSTS        MMDENB
     C                   MOVEL     HLORCM        ILRORM
     C                   MOVEL     HLMORI        ILRORI
     C                   MOVEL     HLDCPI        ILRCPI
     C                   MOVEL     HLMOPM        ILROPM
     C                   MOVEL     HLMOPI        ILROPI
     C                   MOVEL     HLDCRI        ILRCRI
     C                   Z-ADD     HLAMNP        ILRBAT
     C                   MOVEL     HLCCY         ILRBCY
     C**********         Z-ADD     HLCNUM        ILRCNM                                       CSD027
     C                   EVAL      ILRCNM = HLCNUM                                            CSD027
     C                   Z-ADD     @HLVDY        ILRVDT
     C                   MOVEL     HLDSTS        ILRSTS
     C                   MOVEL     HLCSNM        ILRCSN
     C                   Z-ADD     HLINTR        ILRIRT
     C                   Z-ADD     @HLNIY        ILRNID
     C                   MOVEL     HLIPFQ        ILRIPF
     C                   MOVEL     HLICMT        ILRICM
     C                   Z-ADD     HLIPDM        ILRIDM
     C                   Z-ADD     HLFVAL        ILRFVL
     C                   Z-ADD     HLFRAT        ILRFRT
     C                   MOVEL     HLISUR        ILRISR
     C                   Z-ADD     @HLSLY        ILRLID
     C                   Z-ADD     @HLMDY        ILRMTD
     C                   Z-ADD     HLNANV        ILRNAV
     C     HLMTYP        IFEQ      'C1'
     C     HLMTYP        OREQ      'C2'
     C     HLMTYP        OREQ      'BP'
     C     HLMTYP        OREQ      'BD'
     C                   Z-ADD     HLINTR        ILRYLD
     C                   ELSE
     C                   Z-ADD     HLDCRT        ILRYLD
     C                   END
     C                   END
      *
      * IF INSERT, BYPASS
      *
     C     @@LACT        CABEQ     'I'           BYPASS
      *
      * GET THE 'BEFORE' STATUS OF THE DEAL
      *
     C                   MOVEL     Z#BSTS        MMDENS
      *
      * SET 'BEFORE UPDATE' FIELDS ON THE STANDARD DEAL
      *
     C                   MOVEL     HMORCM        ILBORM
     C                   MOVEL     HMMORI        ILBORI
     C                   MOVEL     HMDCPI        ILBCPI
     C                   Z-ADD     HMAMNP        ILBAMT
     C                   MOVEL     HMCCY         ILBUCY
     C**********         MOVEL     HMCNUM        ILBCNM                                       CSD027
     C                   EVAL      ILBCNM = HMCNUM                                            CSD027
     C                   Z-ADD     @HMVDY        ILBVDT
     C                   MOVEL     HMDSTS        ILBSTS
     C                   MOVEL     HMCSNM        ILBCSN
     C                   Z-ADD     HMINTR        ILBIRT
     C                   Z-ADD     @HMNIY        ILBNID
     C                   MOVEL     HMIPFQ        ILBIPF
     C                   MOVEL     HMICMT        ILBICM
     C                   Z-ADD     HMIPDM        ILBIDM
     C                   Z-ADD     HMFVAL        ILBFVL
     C                   Z-ADD     HMFRAT        ILBFRT
     C                   MOVEL     HMISUR        ILBISR
     C                   Z-ADD     @HMSLY        ILBLID
     C                   Z-ADD     @HMMDY        ILBMTD
     C                   MOVEL     HMROBR        ILBROB
      *
     C     BYPASS        ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    @@LACT            1
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C*
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
     C*****************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
