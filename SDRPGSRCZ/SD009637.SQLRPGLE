     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Validate JMS Technical User')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009637 - Validate JMS Technical User                       *
      *             - A valid iSeries User                            *
      *             - A valid BFTB_USER                               *
      *             - A valid/exist in Validation List                *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD033895           Date 16Apr15               *
      *                 MD021423 *CREATE   Date 30Aug13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD033895 - Correct parameters for UT000033.                  *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-Specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD data area                                                                         CSD101
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD101
      *                                                                                       CSD101
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
     D***PValidList       S             10A   INZ('GPLDAPVL')                                 CSD101
     DPValidList       S             10A   INZ('SDINTFVL')                                    CSD101
     DPLibrary         S             10A
     D***PUserName**   S            256A                                                    MD033895
     D***PPassword1*   S            256A                                                    MD033895
     D***PPassword2*   S            256A                                                    MD033895
     D***PDescrptn**   S             50A                                                    MD033895
     D PUserName       S            100A                                                    MD033895
     D***PPassword1      S            600A                                           MD033895 CSD101
     D PPassword1      S            128A                                                      CSD101
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
     DWCount           S              4  0
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
     C                   EVAL      MsgIDXArr(Idx) = 'USR4623'
     C                   ENDIF
      *
      ** Check if the User exist in Validation List
      *
     C**********         CALL      'UT000033'                                                 CSD101
     C**********         PARM      '*BLANKS'     RtnCode                                      CSD101
     C**********         PARM      'F'           PAction                                      CSD101
     C**********         PARM                    PValidList                                   CSD101
     C**********         PARM                    PLibrary                                     CSD101
     C**********         PARM      UserProfile   PUserName                                    CSD101
     C**********         PARM      *BLANKS       PPassword1                                   CSD101
     C**********         PARM      *BLANKS       PPassword2                                   CSD101
     C**********         PARM      *BLANKS       PDescrptn                                    CSD101
                                                                                              CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PUserName = 'BANKFUSION_' + UserProfile                    CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       RtnCode                                      CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PUserName                                    CSD101
     C                   PARM      *Blanks       PPassword1                                   CSD101
     C                   PARM      *Blanks       PDescrptn                                    CSD101
      *
     C                   IF        RtnCode <> *BLANKS
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR4639'
     C                   ENDIF
     C
      *
      ** Check if the User is authorised in CLIP, LOAM in all branches.
      *
     C                   EVAL      WCount = *ZEROS
     C/EXEC SQL
     C+  SELECT Count(*) into :WCount from MIVW_USER
     C+         WHERE BFNAMEPK = :UserProfile
     C/END-EXEC
      *
      ** If No record, user is not authorised
      *
     C                   IF        WCount < 1
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDXArr(Idx) = 'USR4640'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
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
     C**********         EVAL      RtnCode = *BLANKS                                          CSD101
     C**********         EVAL      POP01 = 'GlobalSystemPrefix'                               CSD101
     C**********         EVAL      PVL01 = *BLANKS                                            CSD101
      *
     C**********         CALL      'AOSVALR0'                                                 CSD101
     C**********         PARM                    RtnCode                                      CSD101
     C**********         PARM                    POP01                                        CSD101
     C**********         PARM                    PVL01                                        CSD101
     C**********         PARM      *BLANKS       POP02                                        CSD101
     C**********         PARM      *BLANKS       PVL02                                        CSD101
     C**********         PARM      *BLANKS       POP03                                        CSD101
     C**********         PARM      *BLANKS       PVL03                                        CSD101
     C**********         PARM      *BLANKS       POP04                                        CSD101
     C**********         PARM      *BLANKS       PVL04                                        CSD101
     C**********         PARM      *BLANKS       POP05                                        CSD101
     C**********         PARM      *BLANKS       PVL05                                        CSD101
     C**********         PARM      *BLANKS       POP06                                        CSD101
     C**********         PARM      *BLANKS       PVL06                                        CSD101
     C**********         PARM      *BLANKS       POP07                                        CSD101
     C**********         PARM      *BLANKS       PVL07                                        CSD101
     C**********         PARM      *BLANKS       POP08                                        CSD101
     C**********         PARM      *BLANKS       PVL08                                        CSD101
     C**********         PARM      *BLANKS       POP09                                        CSD101
     C**********         PARM      *BLANKS       PVL09                                        CSD101
     C**********         PARM      *BLANKS       POP10                                        CSD101
     C**********         PARM      *BLANKS       PVL10                                        CSD101
      *
     C**********         IF        RtnCode = *BLANKS                                          CSD101
     C**********         EVAL      SysPrefix = PVL01                                          CSD101
     C**********         EVAL      PLibrary = SysPrefix + 'GMLIB'                             CSD101
     C**********         ENDIF                                                                CSD101
                                                                                              CSD101
     C                   IN        SDSTAT                                                     CSD101
                                                                                              CSD101
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
