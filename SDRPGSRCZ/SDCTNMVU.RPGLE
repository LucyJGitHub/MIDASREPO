     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SD Currency/Time of Netting Details Validate & Upd')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCTNMVU - SD Currency/Time of Netting Details               *
      *             Validate and Update                               *
      *                                                               *
      *  Function: This program validates Currency/Time of Netting    *
      *            Details API details for input into the Midas       *
      *            database.                                          *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1086546 *CREATE  Date 12Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1086546 - Upgrade of CDL025 to MP1.4 (Child: AR1086547).   *
      *              Applied for MD021813                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------

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

      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      ** Incoming transaction in screen format
     D TranInCtnm    E DS                  EXTNAME(SDCCTNPD)

      ** Valid file layout
     D ValidCtnm     E DS                  EXTNAME(SDVCTNMPD)
     D                                     PREFIX(V_)
      ** Large fields to include
      ** - Receive instructions (xxRSTM to xxROCN)
      ** - Pay     instructions (xxPSTM to xxBTB6)
      ** Separate out settlement instructions

      ** Current transaction record in file format
     D CtnmFilFmt    E DS                  EXTNAME(SDVCTNMPD)
      ** Large fields to include
      ** - Receive instructions (xxRSTM to xxROCN)
      ** - Pay     instructions (xxPSTM to xxBTB6)
      ** Separate out settlement instructions

      ** Current transaction in screen format
     D CurTrCtnm     E DS                  EXTNAME(SDCCTNPD)
     D                                     PREFIX(@)

      ** Error indicators
     D OKTrCtnm      E DS                  EXTNAME(SDECTNMPD)

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      ** First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)

      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A

      ** Indices for arrays used to set up corresponding
      ** sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** From Customer Flag
     D From_cust       S              1

      ** Entry parameters
     D UpdateYN        S              1A
     D Buffer          S           6000A
     D APIRetC         S              1A
     D PTimeStamp      S             26A

     D ModeofOp        S              6A

     D RespMode        S              1A
     D PAuthcomp       S              1A
     D PFwdbck         S              1A
     D DDCUST_IN       S              6A

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
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Incoming transaction is broken into 500A fields, so that a
      ** common CL can be used between this module and the one that
      ** reads the MQ queue.  This module needs to break these 500A
      ** fields by loading them into the appropriate (externally
      ** described) data structure.

     C                   MOVEL     Trans5001     TranInCtnm

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      ** Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      ** Validate action code

     C                   EXSR      ValidateAc

      ** If error in validation of action code, fail this input

     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      ** Processing depends upon action code

     C                   SELECT

      ** Processing for inserts

     C                   WHEN      DDACTN = 'I'
     C                   EXSR      ValidateTr

      ** Processing for amends or changes

     C                   WHEN      DDACTN = 'A'
     C                   EXSR      ValidateTr
     C                   ENDSL

     C     INVALID       TAG

      ** Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF

     C                   SETON                                        LR

      ** If action is for Update, get the correct record information
      ** from file

     C                   IF        UpdateYN = 'Y' AND
     C                             Idx = 0 AND DDACTN <> 'D'
     C                   MOVE      DDCUST        DDCUST_In
     C                   CALL      'SDCTNMR'
     C                   PARM                    PAuthComp
     C                   PARM                    PFwdBck
     C                   PARM                    DDCUST_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
     C                   MOVEL     DDACTN        Buffer
     C                   ELSE

      ** Remerge buffer with all relevant data structures

     C                   EVAL           Buffer = TranInCtnm + PTimeStamp
     C                   ENDIF

     C                   RETURN

      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Common header information (DS) from source system

     C                   PARM                    HeadIn

      ** Transaction information

     C                   PARM                    Trans5001
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    PTimeStamp

      ** Set up the name of the primary and secondary message files
      ** from which the message handler will get the messages

     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'

      ** Hook to enable non-core message files to be included

      /COPY WNCPYSRC,SDCTNMM01

      ** Access bank details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateAc - Routine to validate action code versus          *
      *              Customer Number supplied                         *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR

      ** Validate action code versus Customer Number supplied
      ** The Currency/Time of Netting Details in file format from the SD
      ** database is retrieved as well

     C                   RESET                   ReturnCode
     C                   CALLB     'SDCTNMRTV'

      ** Ensure correct parameters for this RTV function
      ** INPUTS
      ** Return code

     C                   PARM      *BLANK        ReturnCode

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)

     C                   PARM                    ModeofOp

      ** Response mode

     C                   PARM      'S'           APRESPMODE

      ** Action Code

     C                   PARM                    DDACTN

      ** Front Office Transaction ID
      ** Customer Number/Currency Key Fields

     C                   PARM                    DDCUST

      ** From Customer Flag

     C                   PARM      'N'           From_Cust

      ** Outputs
      ** (Current) Currency/Time of Netting Details in file format

     C                   PARM                    CtnmFilFmt

      ** OK - Action code

     C                   PARM                    DDActnOK

      ** OK - Customer Number

     C                   PARM                    DDCUSTOK

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    Idx

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr - Routine to validate the Currency/Time of        *
      *              Netting Details                                  *
      *                                                               *
      *****************************************************************
     C     ValidateTr    BEGSR

      ** Validate Currency/Time of Netting Details

     C                   RESET                   ReturnCode

     C                   CALLB     'SDCTNMVAL'

      ** Inputs
      ** Response mode

     C                   PARM      'S'           RespMode

      ** Currency/Time of Netting Details

     C                   PARM                    TranInCtnm

      ** Ensure validation module is ready to accept infdata and
      ** extdata
      ** OUTPUTS
      ** Currency/Time of Netting Details OK inds

     C                   PARM                    OKTrCtnm

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    WIdx

      ** Valid Currency/Time of Netting (DS) from/to caller

     C                   PARM                    ValidCtnm

      ** Insert correct parameters for this VAL function
      ** - If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETCYCLE- Reset error information that is gradually        *
      *             updated during each run of this program           *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
     C                   RESET                   FldNoArr
     C                   CLEAR                   CurTrCtnm
     C                   MOVE      *ALL'Y'       OKTrCtnm
     C                   CLEAR                   ValidCtnm

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Reset error information that is gradually updated*
      *              during each run of this program                  *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      ** Set file field(s) that are needed for all action codes

     C                   MOVEL     DDCUST        V_TNCUST
     C                   MOVEL     DDNTCP        V_TNNTCP
     C                   MOVEL     DDACTN        V_TNTYLC
     C                   MOVEL     BJRDNB        V_TNLCD
     C                   MOVEL     DDCCY1_1      V_TNCCY1_1
     C                   MOVEL     DDCCY2_1      V_TNCCY2_1
     C                   MOVEL     DDTIME_1      V_TNTIME_1
     C                   MOVEL     DDRNTD_1      V_TNRNTD_1
     C                   MOVEL     DDCCY1_2      V_TNCCY1_2
     C                   MOVEL     DDCCY2_2      V_TNCCY2_2
     C                   MOVEL     DDTIME_2      V_TNTIME_2
     C                   MOVEL     DDRNTD_2      V_TNRNTD_2
     C                   MOVEL     DDCCY1_3      V_TNCCY1_3
     C                   MOVEL     DDCCY2_3      V_TNCCY2_3
     C                   MOVEL     DDTIME_3      V_TNTIME_3
     C                   MOVEL     DDRNTD_3      V_TNRNTD_3
     C                   MOVEL     DDCCY1_4      V_TNCCY1_4
     C                   MOVEL     DDCCY2_4      V_TNCCY2_4
     C                   MOVEL     DDTIME_4      V_TNTIME_4
     C                   MOVEL     DDRNTD_4      V_TNRNTD_4
     C                   MOVEL     DDCCY1_5      V_TNCCY1_5
     C                   MOVEL     DDCCY2_5      V_TNCCY2_5
     C                   MOVEL     DDTIME_5      V_TNTIME_5
     C                   MOVEL     DDRNTD_5      V_TNRNTD_5
     C                   MOVEL     DDCCY1_6      V_TNCCY1_6
     C                   MOVEL     DDCCY2_6      V_TNCCY2_6
     C                   MOVEL     DDTIME_6      V_TNTIME_6
     C                   MOVEL     DDRNTD_6      V_TNRNTD_6
     C                   MOVEL     DDCCY1_7      V_TNCCY1_7
     C                   MOVEL     DDCCY2_7      V_TNCCY2_7
     C                   MOVEL     DDTIME_7      V_TNTIME_7
     C                   MOVEL     DDRNTD_7      V_TNRNTD_7
     C                   MOVEL     DDCCY1_8      V_TNCCY1_8
     C                   MOVEL     DDCCY2_8      V_TNCCY2_8
     C                   MOVEL     DDTIME_8      V_TNTIME_8
     C                   MOVEL     DDRNTD_8      V_TNRNTD_8
     C                   MOVEL     DDCCY1_9      V_TNCCY1_9
     C                   MOVEL     DDCCY2_9      V_TNCCY2_9
     C                   MOVEL     DDTIME_9      V_TNTIME_9
     C                   MOVEL     DDRNTD_9      V_TNRNTD_9
     C                   MOVEL     DDCCY1_10     V_TNCCY1_10
     C                   MOVEL     DDCCY2_10     V_TNCCY2_10
     C                   MOVEL     DDTIME_10     V_TNTIME_10
     C                   MOVEL     DDRNTD_10     V_TNRNTD_10

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATEDB - Update database                                   *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR

      ** Update

     C                   RESET                   ReturnCode

     C                   CALLB     'SDCTNMUPD'

      ** Ensure correct parameters for this UPD function

     C                   PARM                    @RTCD
     C                   PARM                    ValidCTNM
     C                   PARM      'N'           From_Cust

      ** If there were any errors in the update functions, rollback any
      ** updates (done in *PSSR) and end this program. Otherwise commit.

     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   EndIf

      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)

     C                   MOVEL     'USR0015'     MsgIdArr(1)

     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
