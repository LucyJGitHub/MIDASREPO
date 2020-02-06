     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Booking Profit Centre')
      *****************************************************************
      *                                                               *
      *  Midas SE - Midas Security Trading validation module.         *
      *                                                               *
      *  SEVTBPRFCN - Validate Trade booking profit centre            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
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
      *                 BUG1088            Date 20Mar06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198112             Date 30Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 171460             Date 22Oct99               *
      *                 167953             Date 27Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAC005             Date 23Nov98               *
      *                 CAP003  *CREATE    Date 09Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10880 - Ensure that book profit centre will not be left   *
      *             blank. Reverse 198112.                            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  198112 - Profit Center should be optional if CAC005 is off   *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  171460 - Amend '?' processing for Profit centres             *
      *  167953 - Correct Profit Centre defaulting                    *
      *  CAC005 - Profit Centre Accounting - SE Enhancement           *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSEPCBD    IF   E           K DISK
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** Portfolio details data structure used by called program within module
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      * Client Details data structure                                                         167953
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  167953
 
      ** Dummy data field used by called program within module
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs, long data structure                                   167953
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     167953
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*TCNR*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
     D @KEY1           S             10A                                                      167953
     D @KYST           S              7A                                                      167953
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   MOVEL     *BLANK        BPRC
      *
      ** DEFAULT
      *
     C     Default       IFEQ      'Y'
     C     DDBPRC        ANDEQ     *BLANK
                                                                                CAC005
      * If PCA SE enhancement CAC005 is on                                      CAC005
                                                                                CAC005
     C     CAC005        IFEQ      'Y'                                          CAC005
     C                   EXSR      BPRCD_CAC5                                   CAC005
     C                   ELSE                                                   CAC005
     C                   EXSR      BPRCD
     C                   END                                                    CAC005
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
                                                                                CAC005
      * If PCA SE enhancement CAC005 is on                                      CAC005
                                                                                CAC005
     C     CAC005        IFEQ      'Y'                                          CAC005
     C                   EXSR      BPRCV_CAC5                                   CAC005
     C                   ELSE                                                   CAC005
     C                   EXSR      BPRCV
     C                   END                                                    CAC005
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDBprcOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     BPRCV         BEGSR
      *
      ** Booking Profit Centre
      *
     C                   MOVEL     DDBPBK        BOKC
     C                   MOVEL     DDBRCD        BRCA
     C                   MOVEL     DDSESN        SESN
     C                   MOVEL     DDTDMI        MKTI
 
     C     KLSPCB        CHAIN     SEPCBD                             44
      *
      ** If a book position profit centre record exists and the
      ** profit centre entered is not what is on this record,
      ** overwrite it and send a warning message
      *
     C     *IN44         IFEQ      '0'
     C     DDBPRC        ANDNE     PCBK
 
     C                   MOVE      PCBK          DDBPRC
     C                   ADD       1             WIx
     C                   MOVEL     'MMA0526'     WMsgidXAr(WIx)
     C                   MOVEL     'DDBPRC'      WFldNmXAr(WIx)
     C                   MOVE      'W'           DDBPRCOk
 
     C                   END
      *
      ** Book Profit Centre is required
      *
     C     DDBPRC        IFEQ      *BLANKS
     C*****CAC005        IFEQ      'Y'                                               198112 BUG10880
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPRC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0523'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDBPRCOk
     C**********         END                                                         198112 BUG10880
      *
      ** Book Profit Centre must be a valid profit centre
      *
     C                   ELSE
      *
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBPRC        @PCCD             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDBPRC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0525'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDBPRCOk
     C                   ELSE                                                   171460
     C                   MOVE      DSPCCD        BPRC                           171460
     C                   ENDIF
 
     C                   ENDIF
      *
      * Update trade
      *
     C***********        MOVE      DDBPRC        BPRC                           171460
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                    CAC005
      *****************************************************************         CAC005
      ** VALIDATION IF CAC005 IS INSTALLED                                      CAC005
      *****************************************************************         CAC005
     C     BPRCV_CAC5    BEGSR                                                  CAC005
      *                                                                         CAC005
      ** Book Profit Centre is required                                         CAC005
      *                                                                         CAC005
     C     DDBPRC        IFEQ      *BLANKS                                      CAC005
     C                   ADD       1             Idx                            CAC005
     C                   MOVEL     'DDBPRC'      FldNamXAr(Idx)                 CAC005
     C                   MOVEL     'MMA0523'     MsgidXAr(Idx)                  CAC005
     C                   MOVE      'N'           DDBPRCOk                       CAC005
      *                                                                         CAC005
      ** Book Profit Centre must be a valid profit centre                       CAC005
      *                                                                         CAC005
     C                   ELSE                                                   CAC005
      *                                                                         CAC005
     C                   CALL      'AOPRFCR0'                                   CAC005
     C                   PARM      *BLANKS       @RTCD                          CAC005
     C                   PARM      '*KEY   '     @OPTN                          CAC005
     C                   PARM      DDBPRC        @PCCD                          CAC005
     C     SDPRFC        PARM      SDPRFC        DSFDY                          CAC005
     C*                                                                         CAC005
     C     @RTCD         IFNE      *BLANKS                                      CAC005
     C                   ADD       1             Idx                            CAC005
     C                   MOVEL     'DDBPRC'      FldNamXAr(Idx)                 CAC005
     C                   MOVEL     'MMA0525'     MsgidXAr(Idx)                  CAC005
     C                   MOVE      'N'           DDBPRCOk                       CAC005
     C                   ELSE                                                   171460
     C                   MOVE      DSPCCD        BPRC                           171460
     C                   ENDIF                                                  CAC005
                                                                                CAC005
     C                   ENDIF                                                  CAC005
      *                                                                         CAC005
      * If booking profit centre is OK                                          CAC005
      *                                                                         CAC005
     C     DDBprcOK      IFNE      'N'                                          CAC005
      *                                                                         CAC005
      * Update trade booking profit centre                                      CAC005
      *                                                                         CAC005
     C                   MOVE      DDBPRC        BPRC                           CAC005
      *                                                                         CAC005
      ** Get pseudo book to put onto trade                                      CAC005
      *                                                                         CAC005
     C                   CALL      'AOBKPCR0'                                   CAC005
     C                   PARM      *BLANKS       P@RTCD            7            CAC005
     C                   PARM      '*PSEUDO'     P@OPTN            7            CAC005
     C                   PARM      DDBPBK        P@BKCD            2            CAC005
     C                   PARM      DDBPRC        P@PRFC            4            CAC005
     C                   PARM                    P@PSBK            2            CAC005
     C     P@RTCD        IFNE      *BLANKS                                      CAC005
     C                   ADD       1             Idx                            CAC005
     C                   MOVEL     'DDBPRC'      FldNamXAr(Idx)                 CAC005
     C                   MOVEL     'MMA0529'     MsgidXAr(Idx)                  CAC005
     C                   MOVE      'N'           DDBPRCOk                       CAC005
     C                   ELSE                                                   CAC005
     C                   MOVEL     P@PSBK        TDBK                           CAC005
     C                   ENDIF                                                  CAC005
     C                   ENDIF                                                  CAC005
      *                                                                         CAC005
     C                   ENDSR                                                  CAC005
      *****************************************************************         CAC005
     C/EJECT
      *****************************************************************
      ** DEFAULT
      *****************************************************************
     C     BPRCD         BEGSR
      *
      ** Default Booking Profit Centre
      *
     C                   MOVEL     DDBPBK        BOKC
     C                   MOVEL     DDBRCD        BRCA
     C                   MOVEL     DDSESN        SESN
     C                   MOVEL     DDTDMI        MKTI
 
     C     KLSPCB        CHAIN     SEPCBD                             44
      *
      ** If a book position profit centre record exists
      ** default the profit centre to what is on this record.
      *
     C     *IN44         IFEQ      '0'
     C                   MOVE      PCBK          DDBPRC
     C*
     C** Else default from matrix
     C*
     C                   ELSE
     C     BKPCDU        IFEQ      'Y'
     C                   EXSR      AOPRFM
     C     #RTCD         IFEQ      '0'
     C                   MOVE      @PRFC         DDBPRC
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                    CAC005
      *****************************************************************         CAC005
      ** DEFAULT IF CAC005 IS INSTALLED                                         CAC005
      *****************************************************************         CAC005
     C     BPRCD_CAC5    BEGSR                                                  CAC005
      *                                                                         CAC005
      ** Default Booking Profit Centre from matrix                              CAC005
      *                                                                         CAC005
     C                   EXSR      AOPRFM                                       CAC005
     C     #RTCD         IFEQ      '0'                                          CAC005
     C                   MOVE      @PRFC         DDBPRC                         CAC005
     C                   END                                                    CAC005
                                                                                CAC005
     C                   ENDSR                                                  CAC005
      *****************************************************************         CAC005
      /EJECT
      *****************************************************************
      * AOPRFM - Profit Centre Matrix Access                          *
      *****************************************************************
     C     AOPRFM        BEGSR
      *                                                                                       167953
      ** Get account officer for matrix defaulting                                            167953
      *                                                                                       167953
     C                   MOVEL     TCNR          @KEY1                                        167953
     C                   CALLB     'AOCUSTR0'                                                 167953
     C                   PARM      *BLANKS       @RTCD                                        167953
     C                   PARM      '*KEY   '     @OPTN                                        167953
     C                   PARM                    @KEY1                                        167953
     C                   PARM      *BLANKS       @KYST                                        167953
     C     SDCUST        PARM      SDCUST        DSSDY                                        167953
                                                                                              167953
     C                   MOVE      *BLANKS       @ACOC                                        167953
     C     @RTCD         IFEQ      *BLANKS                                                    167953
     C                   MOVEL     BBACOC        @ACOC                                        167953
     C                   ENDIF                                                                167953
 
     C                   MOVEL     DDTDTP        @TRTY
     C                   MOVEL     TCNR          @CUST
 
     C                   CALLB     'AOPRFMR0'
     C                   PARM      *BLANKS       #RTCD             1
     C                   PARM      DDBPBK        @BKCD             2
     C                   PARM                    @TRTY             5
     C                   PARM      DDTSUB        @SBTY             2
     C                   PARM      DDBRCD        @BRCD             3
     C                   PARM      *BLANKS       @DPCD             3
     C                   PARM      PSUser        @USID            10
     C*******************PARM      *BLANKS       @ACOC             2                          167953
     C                   PARM                    @ACOC             2                          167953
     C                   PARM                    @CUST             6
     C                   PARM                    @PRFC             4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Booking profit centre
     C                   PARM                    DDBPRC            4
 
      ** Security
      ** Trade Type
      ** Branch code
      ** Book code
      ** Market Indicator
      ** Trade Sub Type
     C                   PARM                    DDSESN           10
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDBPBK            2
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDTSUB            2
      *
      ** Trade Customer
     C                   PARM                    TCNR
      *
      ** ICD
     C                   PARM                    BKPCDU            1
     C                   PARM                    CAC005            1            CAC005
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Booking profit centre - OK
     C                   PARM                    DDBprcOK          1            broker
      *
      ** Trade Booking profit centre
      *
     C                   PARM                    BPRC              4            broker
      *                                                                         CAC005
      ** Trade Book                                                             CAC005
      *                                                                         CAC005
     C                   PARM                    TDBK              2            CAC005
      *
      ** Key list for SEPCBD
      *
     C     KLSPCB        KLIST
     C                   KFLD                    BOKC
     C                   KFLD                    BRCA
     C                   KFLD                    SESN
     C                   KFLD                    MKTI
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
