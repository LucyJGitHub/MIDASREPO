     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Return Password from Validation List')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD00002PR - Return Password from Validation List             *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CSD101   *CREATE   Date 07Dec18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
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
     D   Password      S            128
      *
      ** Validation List Parameter
     D PRtnCode        S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PUserName       S            100A
     D PPassword1      S            128A
     D PPassword2      S            600A
     D PDescrptn       S           1000A
     D GlobalPref      S              2A

     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')

     DValidList        C                   CONST('SDINTFVL')

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
     C                   Eval      Password = *BLANKS
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

     C                   EVAL      PValidList = ValidList
     C                   EVAL      PLibrary = LIBR + 'DMLIB'
     C                   EVAL      PUserName = 'PEA_' + UserName

     C                   CALL      'SD000404'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM                    PUserName
     C                   PARM      *Blanks       PPassword1
     C                   PARM      *Blanks       PDescrptn
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   Eval      ReturnCode = '*ERROR'
     C                   MOVEL     UserName      DBKEY
     C                   EVAL      DBFILE = 'SDINTFVL'
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

     C                   IN        SDSTAT

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
(c) Finastra International Limited 2018
