     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Validate BITP SOAP User ID system value')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009602 - Validate a PDP User ID for the following:         *
      *             - A valid iSeries User                            *
      *             - A valid BFTB_USER in BITP                       *
      *             - A valid/exist in Validation List                *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD033895           Date 16Apr15               *
      *                 MD023396A          Date 19Nov13               *
      *                 CGL135A  *CREATE   Date 11Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033895 - Correct parameters for UT000033.                  *
      *  MD023396A - Replaced incorrect index code being validated.   *
      *  CGL135A - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Branch Codes
      *
     FSDBRCHL1  IF   E           K DISK
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-Specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Data structure for CurrentValue string
     D CurrentValue    DS           200
     D  UserProfile            1     10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Error message id in GBSDUSRMSG
      *
     D ErrMsgId        S              7A
      *
      ** System value to be processed
      *
     D SystemValue     S             20A
      *
      ** Processing mode
      *
     D ProcMode        S            190A
      *
      ** General error indicator
      *
     D GenError        S              1A
      *
      ** Index for arrays of of error message ids etc
      *
     D Idx             S              2P 0
      *
      ** Array of error message IDs
      *
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
      *
      ** UT000033 Parameters
      *
     DPRtnCode         S              7A
     DPAction          S              1A
     DPValidList       S             10A   INZ('GPLDAPVL')
     DPLibrary         S             10A
     D***PUserName**   S            256A                                                    MD033895
     D***PPassword1*   S            256A                                                    MD033895
     D***PPassword2*   S            256A                                                    MD033895
     D***PDescrptn**   S             50A                                                    MD033895
     D PUserName       S            100A                                                    MD033895
     D PPassword1      S            600A                                                    MD033895
     D PPassword2      S            600A                                                    MD033895
     D PDescrptn       S           1000A                                                    MD033895
      *
      ** Other Parameter
      *
     DRtnCode          S             10
     DObjName          S             10
     DObjLib           S             10
     DObjType          S              8
     DChkMbr           S             10
     D@Actn            S              1A
     D@Brch            S              3A
     D@Error           S              1P 0
      *
      ** System Value Parameter
      *
     D SeqFlg          S              1A
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A

     D SysPrefix       S              2A
     DBITP_Count       S              4  0
     DSQL_Err          S              1A
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Check if the User is a valid iSeries user
      *
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      UserProfile   ObjName
     C                   PARM      '*LIBL'       ObjLib
     C                   PARM      '*USRPRF'     ObjType
     C                   PARM                    ChkMbr
      *
      ** If the user does not exist in the library list, send message
      ** Object not exists in *LIBL.
      *
     C                   IF        RtnCode <> 'Exist'
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR0763'
     C                   ENDIF
      *
      ** Check if the User exist in Validation List
      *
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     RtnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      UserProfile   PUserName
     C                   PARM      *BLANKS       PPassword1
     C                   PARM      *BLANKS       PPassword2
     C                   PARM      *BLANKS       PDescrptn
      *
     C                   IF        RtnCode <> *BLANKS
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR4639'
     C                   ENDIF
     C
      *
      ** Check if the User is authorised in Journal Entry all branches.
      *
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1
     C                   DOW       Not %EOF

     C                   EVAL      BITP_Count = *ZEROS
      *
      ** Check if User is authorised in Journal Entry Menu
      *
     C/EXEC SQL
     C+  SELECT Count(*) into :BITP_Count from MIVW_PERMM
     C**********+         WHERE INDX = '*G00000038'                                        MD023396A
     C+         WHERE INDX = '0000001630'                                                  MD023396A
     C+           AND BRCB = :A8BRCD AND USRP = :UserProfile
     C/END-EXEC
      *
      ** If No record, user is not authorised
      *
     C                   IF        BITP_Count < 1
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR4641'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   READ      SDBRCHL1
     C                   ENDDO
      *
      ** Catchall for unprocessed errors
      *
     C                   IF        RtnCode <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Normal end processing
      *
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON

     C                   RETURN
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      ** System value to be processed
      *
     C                   PARM                    SystemValue
      *
      ** Value entered by user
      *
     C                   PARM                    CurrentValue
      *
      ** Processing Mode
      *
     C                   PARM                    ProcMode
      *
      ** General Error Indicator
      *
     C                   PARM                    GenError
      *
      ** Error message ID (number of entries)
      *
     C                   PARM                    Idx
      *
      ** Error message ID (array)
      *
     C                   PARM                    MsgIDXArr
      *
      ** Get Global System Prefix
      *
     C                   EVAL      RtnCode = *BLANKS
     C                   EVAL      POP01 = 'GlobalSystemPrefix'
     C                   EVAL      PVL01 = *BLANKS
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    RtnCode
     C                   PARM                    POP01
     C                   PARM                    PVL01
     C                   PARM      *BLANKS       POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM      *BLANKS       POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM      *BLANKS       POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM      *BLANKS       POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
      *
     C                   IF        RtnCode = *BLANKS
     C                   EVAL      SysPrefix = PVL01
     C                   EVAL      PLibrary = SysPrefix + 'GMLIB'
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
