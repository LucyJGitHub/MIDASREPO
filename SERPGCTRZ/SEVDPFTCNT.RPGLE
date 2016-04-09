 
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Profit Centre')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVPRFTCNT - Validate Profit Centre                          *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Profit Centre field for Depot Movement.           *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *                                                               *
      *  Component of: SE0070 - Depot Movement Maintenance.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 167953             Date 27Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003 *CREATE     Date 24Apr98               *
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
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  167953 - Correct Profit Centre defaulting                    *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEPCCD    IF   E           K DISK
 
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** First DS for ACCESS Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs, long data structure                                   167953
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     167953
 
      ** External DS for PROFIT CENTRES details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      * Client Details data structure                                                         167953
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  167953
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen Inputs
     D DDDPPC          S              4A
 
      ** Depot movement details
     D DPBA            S              3A
     D DPBK            S              2A
     D*DPBN*****       S              6S 0                                                    CSD027
     D DPBN            S              6A                                                      CSD027
     D DPSS            S             10A
 
      ** System Details
     D PROFCTRU        S              1A
     D BGN0ST          S              1A
     D BKPCDU          S              1A
     D BVSEPC          S              4A
 
      *** Output ***
     D DPPC            S              4A
     D DDDPPCOk        S              1A
 
 
 
     ** Working Variables
     ** -----------------
 
     D @ACOF           S              2A
     D @BOOK           S              2A
     D @BRAN           S              3A
     D @CNUM           S              6A
     D @DEPT           S              3A
     D @PKEY           S              4A
     D @PRFC           S              4A
     D @RTC1           S              1A
     D @SUTP           S              2A
     D @TRTP           S              5A
     D @USER           S             10A
     D @KEY1           S             10A                                                      167953
     D @KYST           S              7A                                                      167953
 
      ** Index for arrays of error message ids etc
 
     D Idx             S              3P 0
 
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
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
     C                   MOVEL     *BLANKS       DPPC
      *
      ** Validation
      *
     C                   EXSR      DPPCV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPPCOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DPPCV - Validation routine for Profit Centre                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPPCV         BEGSR
      *
      ** Profit Center If Used (*IN87)
      *
     C     ProfCtrU      IFEQ      'Y'
      *
      ** If blank, fetch default
      *
     C     DDDPPC        IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       DPPC
     C                   SETOFF                                       33
      *
      ** If amendment type is a WALK IN or a WALK OUT look up on
      ** Customer Positions Profit Centers field for default
      *
     C     DPMVType      IFEQ      'WI'
     C     DPMVType      OREQ      'WO'
 
     C     SEPCCK        KLIST
     C                   KFLD                    DPBN
     C                   KFLD                    DPBA
     C                   KFLD                    DPSS
 
     C     SEPCCK        CHAIN     SEPCCDF                            33
 
     C     *IN33         IFEQ      '0'
     C                   MOVEL     PCCU          DPPC
     C                   MOVEL     PCCU          DDDPPC
     C                   END
 
     C                   END
      *
      ** If not one of these amendment types or record not found
      ** look up default using default matrix. If Profit Centres
      ** default used is yes on PF/SDGELRPD.
      *
     C     BKPCDU        IFEQ      'Y'
 
     C     DPMVType      IFNE      'WI'
     C     DPMVType      ANDNE     'WO'
     C     *IN33         OREQ      '1'
      *                                                                                       167953
      ** Get account officer for matrix defaulting                                            167953
      *                                                                                       167953
     C                   MOVEL     DPBN          @KEY1                                        167953
     C                   CALLB     'AOCUSTR0'                                                 167953
     C                   PARM      *BLANKS       @RTCD                                        167953
     C                   PARM      '*KEY   '     @OPTN                                        167953
     C                   PARM                    @KEY1                                        167953
     C                   PARM      *BLANKS       @KYST                                        167953
     C     SDCUST        PARM      SDCUST        DSSDY                                        167953
                                                                                              167953
     C                   MOVE      *BLANKS       @ACOF                                        167953
     C     @RTCD         IFEQ      *BLANKS                                                    167953
     C                   MOVEL     BBACOC        @ACOF                                        167953
     C                   ENDIF                                                                167953
                                                                                              167953
     C                   MOVEL     DPBN          @CNUM
 
     C                   CALLB     'AOPRFMR0'
     C                   PARM      *BLANKS       @RTC1
     C                   PARM      DPBK          @BOOK
     C                   PARM      *BLANKS       @TRTP
     C                   PARM      *BLANKS       @SUTP
     C                   PARM      DPBA          @BRAN
     C                   PARM      *BLANKS       @DEPT
     C                   PARM      PsUser        @USER
     C*******************PARM      *BLANKS       @ACOF                                        167953
     C                   PARM                    @ACOF                                        167953
     C                   PARM                    @CNUM
     C                   PARM      *BLANKS       @PRFC
 
     C     @RTC1         IFEQ      '0'
     C                   MOVEL     @PRFC         DPPC
     C                   MOVEL     @PRFC         DDDPPC
     C                   END
 
     C                   END
     C                   END
      *
      **  If Analytical Accounting is installed, profit centre is
      **  mandatory for Walk-In/Walk-out.
      *
     C     BGN0ST        IFEQ      'Y'
     C     DDDPPC        ANDEQ     *BLANKS
 
     C     DPMVType      IFEQ      'WI'
     C     DPMVType      OREQ      'WO'
      *
      ** Error 311
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPPC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0208'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPPCOk
     C                   ELSE
     C                   MOVEL     BVSEPC        DPPC
     C                   MOVEL     BVSEPC        DDDPPC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
      *
      ** Else, verify Profit Centre that was input
      *
      *
      **  If Analytical Accounting is installed, profit centre should
      **  be same as the customer profit centre for Walk-In/Walk-out.
      *
     C     BGN0ST        IFEQ      'Y'
 
     C     DPMVType      IFEQ      'WI'
     C     DPMVType      OREQ      'WO'
     C     SEPCCK        CHAIN     SEPCCDF                            37
 
     C     *IN37         IFEQ      '0'
     C     DDDPPC        ANDNE     PCCU
      *
      ** Error 312
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPPC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0230'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPPCOk
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
     C                   CALLB     'AOPRFCR0'
 
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDDPPC        @PKEY
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     DSPCCD        DDDPPC
     C                   MOVEL     DDDPPC        DPPC
     C                   ELSE
      *
      ** Error 234
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPPC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0359'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPPCOk
     C                   END
      *
     C                   END
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received parameters
      ** -------------------
 
      ** Screen fields
      ** Profit Center from caller (4A)
     C                   PARM                    DDDPPC
 
      ** Transaction Details
      ** Branch from caller (3A)
      ** Book from caller (2A)
      ** Beneficiary customer from caller (6S 0)
      ** Security Shortname from caller (10A)
      ** Depot Movement Type
 
     C                   PARM                    DPBA
     C                   PARM                    DPBK
     C                   PARM                    DPBN
     C                   PARM                    DPSS
     C*******************PARM                    DPMVType          1                          167953
     C                   PARM                    DPMVType          2                          167953
 
      ** System Details
      ** Profit Center Used indicator (1A)
      ** Analytical Accounting Indicator (1A)
      ** PROFIT Center Default Used Indicator (1A)
      ** SE Profit Center (4A)
     C                   PARM                    PROFCTRU
     C                   PARM                    BGN0ST
     C                   PARM                    BKPCDU
     C                   PARM                    BVSEPC
 
      ** Returned parameters
      ** -------------------
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Profit Center Ok Indicator (1A)
      ** Profit Center (4A)
     C                   PARM                    DDDPPCOk
     C                   PARM                    DPPC
 
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
