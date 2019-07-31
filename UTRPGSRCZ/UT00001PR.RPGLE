     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SP Retrun Password from Validation List')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  UT00001PR - Transaction validate and update adoption         *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD033895           Date 16Apr15               *
      *                 MD021423 *CREATE   Date 21Aug13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033895 - Correct parameters for UT000033.                  *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      ** SD data area                                                                         CSD101
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD101
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** System Value Parameter
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

      ** Entry parameters
     D   UserName      S             10
     D***Password      S             10                                                       CSD101
     D   Password      S            128                                                       CSD101
      *
      ** Validation List Parameter
     D PRtnCode        S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D***PUserName**   S            256A                                                    MD033895
     D***PPassword1*   S            256A                                                    MD033895
     D***PPassword2*   S            256A                                                    MD033895
     D***PDescrptn**   S             50A                                                    MD033895
     D PUserName       S            100A                                                    MD033895
     D***PPassword1      S            600A                                           MD033895 CSD101
     D PPassword1      S            128A                                                      CSD101
     D PPassword2      S            600A                                                    MD033895
     D PDescrptn       S           1000A                                                    MD033895
     D GlobalPref      S              2A

     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')

     D**ValidList        C                   CONST('GPLDAPVL')                                CSD101
     DValidList        C                   CONST('SDINTFVL')                                  CSD101

     D Parm            DS          3200
     D OffSetB               361    364B 0
     D LibCountB             365    368B 0

     D Len             S              4B 0 INZ(3200)


      * If this Message array needs to increase a separate parameter will need to be added
     D MsgArrOut       S           9999    INZ(*BLANKS)

     D OffLen          S              9  0
     D OffSet          S              9  0
     D InLibl          S           2750
     D Command         S           2764

      * Error message format for retrieve jobd libl
     DQUSEC            DS
      *                                             Qus EC
     D QUSBPRV                 1      4B 0
      *                                             Bytes Provided
     D QUSBAVL                 5      8B 0
      *                                             Bytes Available
     D QUSEI                   9     15
      *                                             Exception Id
     D QUSERVED               16     16
      *                                             Reserved
      *QUSED01                17     17
      *                                             Varying length
     D QUSExcData             17     46
      *                                             Varying length field Exception Data

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C     *ENTRY        PLIST
     C     System        PARM                    Sys               2
     C                   PARM                    ReturnCode
     C                   PARM                    UserName
     C                   PARM                    Password

     C                   Eval      ReturnCode = *BLANKS
     C                   Eval      Password = *BLANKS                                         CSD101
      *
      * Set up job description library list
     C                   Call      'QWDRJOBD'                           9697
     C                   Parm                    Parm
     C                   Parm                    Len
     C                   Parm      'JOBD0100'    Format           10
     C                   Parm                    Jobd
     C                   Parm                    QUSEC
     C                   If        QUSEI = 'CPF9801' OR
     C                             QUSEI = 'CPF9810'
     C                   Eval      ReturnCode = '*ERROR'
     C                   Return
     C                   Endif
     C                   If        QUSEI = 'CPF9802' OR
     C                             QUSEI = 'CPF9820'
     C                   Eval      ReturnCode = '*ERROR'
     C                   Return
     C                   Endif
      *
     C                   Eval      OffSet = OffSetB + 1
     C                   Eval      OffLen = LibCountB * 11
     C                   Eval      InLibl = %SubSt(Parm:OffSet:OffLen)
     C                   Eval      Command = ('CHGLIBL LIBL(' +
     C                             InLibl + ')')

     C                   Call      'QCMDEXC'                              92
     C                   Parm                    Command
     C                   Parm      2764          Length           15 5

     C**********         EVAL      @RTCD = *BLANKS                                            CSD101
     C**********         EVAL      POP01 = 'GlobalSystemPrefix'                               CSD101
     C**********         EVAL      PVL01 = *BLANKS                                            CSD101

     C**********         CALL      'AOSVALR0'                                                 CSD101
     C**********         PARM                    @RTCD                                        CSD101
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

     C**********         IF        @RTCD = *BLANKS                                            CSD101
     C**********         MOVEL     PVL01         GlobalPref                                   CSD101
     C**********         ENDIF                                                                CSD101
      *
     C                   EVAL      PValidList = ValidList
     C**********         EVAL      PLibrary = GlobalPref + 'GMLIB'                            CSD101
      *
     C**********         CALL      'UT000033'                                                 CSD101
     C**********         PARM      '*BLANKS'     PRtnCode                                     CSD101
     C**********         PARM      'F'           PAction                                      CSD101
     C**********         PARM                    PValidList                                   CSD101
     C**********         PARM                    PLibrary                                     CSD101
     C**********         PARM      UserName      PUserName                                    CSD101
     C**********         PARM      *BLANKS       PPassword1                                   CSD101
     C**********         PARM      *BLANKS       PPassword2                                   CSD101
     C**********         PARM      *BLANKS       PDescrptn                                    CSD101
                                                                                              CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PUserName = 'BANKFUSION_' + UserName                       CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PRtnCode                                     CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PUserName                                    CSD101
     C                   PARM      *Blanks       PPassword1                                   CSD101
     C                   PARM      *Blanks       PDescrptn                                    CSD101
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   Eval      ReturnCode = '*ERROR'
     C                   MOVEL     UserName      DBKEY
     C**********         EVAL      DBFILE = 'GPLDAPVL'                                        CSD101
     C                   EVAL      DBFILE = 'SDINTFVL'                                        CSD101
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      Password = PPassword1

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /SPACE 5
      ****************************************************************
      *  Initialisation                                              *
      ****************************************************************
     C     *INZSR        BEGSR

      **--------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------

     C                   IN        SDSTAT                                                     CSD101
                                                                                              CSD101
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      MsgArrOUT = ':::System error has +
     C                             occurred in Midas. Please inform +
     C                             a Midas System operator:'
     C                   RETURN
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2013
