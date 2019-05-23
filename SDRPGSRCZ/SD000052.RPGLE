     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Sending of Message to Compliance Watch')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD000052 - Sending of Message to Compliance Watch            *
      *                                                               *
      *  Function:  This module will call the java class method       *
      *             startKYCInterface to invoke the sending of        *
      *             message to Compliance Watch.                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD028  *CREATE    Date 22Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit  - Initialization                                     *
      *  SRSend  - Subroutine to send the message to compliance       *
      *             watch thry java method startKYCInterface          *
      *  SRCheck - Subroutine to check the status of sending message  *
      *            to compliance watch. If sending is succesful,      *
      *            delete record from Messate to Compliance watch     *.
      *            file. If not, end the program if called from I/C   *
      *            else generate a report.                            *
      *  SRPrtExcptRpt - Subroutine to print customer which failed    *
      *                  to be sent.                                  *
      *  SRPrtTrailRpt - Subroutine to print trailer                  *
      *  SRPrtAuditRpt - Subroutine to print audit report             *
      *  SRDeleteMsg   - Subroutine to delete nessage record          *
      *  SRSetCMI      - Subroutine to set CustomerMessageInfo fields *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCWMGL0  UF A E           K DISK    INFSR(*PSSR)
      * Message to Compliance Watch
 
     FSD000052P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      ** Sending Message to Compliance Watch Status report
 
     FSD000052AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      ** Sending Message to Compliance Watch Audit report
 
      *****************************************************************
      /EJECT
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Midas SD Layout for DTAARA                                                           CSD101
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD101
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for SD000052P1
      * for RCF use
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for SD000052AU
      * for RCF use
     D SPOOLU          DS
     D  PSFile2               83     92
     D  PSFNum2              123    124B 0
     D  OflLn2               188    189B 0
     D  PrtLn2               367    368B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * object use to pass as parameter in strKYCInterface method
     D CMIobject       S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo')
 
      * default constructor of CustomerMessageInfo
     D createCMI       PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     *CONSTRUCTOR)
     D                                     CLASS(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo')
 
      * prototype for set KYC Interface method
     D strKYCIntrf     PR            10I 0 EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     util.CustomerMessageManager':
     D                                     'startKYCInterface')
     D                                     STATIC
     D CMIobject                       O   CLASS(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo')
 
      * prototype the string constructor
     D makestr         PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D                                     CLASS(*JAVA:'java.lang.String')
     D  bytes                        50A   CONST VARYING
 
     D setCustNumber   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setCustNumber')
     D CustNumber                      O   CLASS(*JAVA:'java.lang.String')
 
     D addAddress      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'addAddress')
     D Address                         O   CLASS(*JAVA:'java.lang.String')
 
     D addAcctOwnAdd   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'addAcctOwnAdd')
     D AOAddress                       O   CLASS(*JAVA:'java.lang.String')
 
     D setReportName   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setReportName')
     D ReportName                      O   CLASS(*JAVA:'java.lang.String')
 
     D setParentInd    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setParentInd')
     D ParentInd                       O   CLASS(*JAVA:'java.lang.String')
 
     D setCtryCitizen  PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setCtryCitizen')
     D CtryCitizen                     O   CLASS(*JAVA:'java.lang.String')
 
     D setBrchCode     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setBrchCode')
     D BrchCode                        O   CLASS(*JAVA:'java.lang.String')
 
     D setCtryDom      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setCtryDom')
     D CtryDom                         O   CLASS(*JAVA:'java.lang.String')
 
     D setBrchInd      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setBrchInd')
     D BrchInd                         O   CLASS(*JAVA:'java.lang.String')
 
     D setBankInd      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setBankInd')
     D BankInd                         O   CLASS(*JAVA:'java.lang.String')
 
     D setDatFstCont   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setDatFstCont')
     D DatFstCont                      O   CLASS(*JAVA:'java.lang.String')
 
     D setInstCode     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setInstCode')
     D InstCode                        O   CLASS(*JAVA:'java.lang.String')
 
     D setTelephone    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setTelephone')
     D Telephone                       O   CLASS(*JAVA:'java.lang.String')
 
     D setIndustry     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setIndustry')
     D Industry                        O   CLASS(*JAVA:'java.lang.String')
 
     D setAccHldTyp    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setAccHldTyp')
     D AccHldTyp                       O   CLASS(*JAVA:'java.lang.String')
 
     D setCustType     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setCustType')
     D CustType                        O   CLASS(*JAVA:'java.lang.String')
 
     D setRtlCustGrp   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setRtlCustGrp')
     D RtlCustGrp                      O   CLASS(*JAVA:'java.lang.String')
 
     D setTelexAdd     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setTelexAdd')
     D TelexAdd                        O   CLASS(*JAVA:'java.lang.String')
 
     D setCorpCust     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setCorpCust')
     D CorpCust                        O   CLASS(*JAVA:'java.lang.String')
 
     D setFaxNum       PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setFaxNum')
     D FaxNum                          O   CLASS(*JAVA:'java.lang.String')
 
     D setIdentityNum  PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setIdentityNum')
     D IdentityNum                     O   CLASS(*JAVA:'java.lang.String')
 
     D setTelexNum     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setTelexNum')
     D TelexNum                        O   CLASS(*JAVA:'java.lang.String')
 
     D setDOB          PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setDOB')
     D DOB                             O   CLASS(*JAVA:'java.lang.String')
 
     D setDatLstVisit  PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setDatLstVisit')
     D DatLstVisit                     O   CLASS(*JAVA:'java.lang.String')
 
     D setMailDtl      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setMailDtl')
     D CustMailDtl                     O   CLASS(*JAVA:'java.lang.String')
 
     D setAcctOwnAdd   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setAcctOwnAdd')
     D AcctOwnAdd                      O   CLASS(*JAVA:'java.lang.String')
     D                                     DIM(4)
 
     D setTinNum       PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setTinNum')
     D TinNum                          O   CLASS(*JAVA:'java.lang.String')
 
     D setBirthTown    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setBirthTown')
     D BirthTown                       O   CLASS(*JAVA:'java.lang.String')
 
     D setBirthCtry    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setBirthCtry')
     D BirthCtry                       O   CLASS(*JAVA:'java.lang.String')
 
     D setCredRating   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setCredRating')
     D CredRating                      O   CLASS(*JAVA:'java.lang.String')
 
     D setIcNum        PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setIcNum')
     D IcNum                           O   CLASS(*JAVA:'java.lang.String')
 
     D setPassNum      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setPassNum')
     D PassNum                         O   CLASS(*JAVA:'java.lang.String')
 
     D setAssetClass   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setAssetClass')
     D AssetClass                      O   CLASS(*JAVA:'java.lang.String')
 
     D addAddlCustFld  PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'addAddlCustFld')
     D AddCustFld                      O   CLASS(*JAVA:'java.lang.String')
 
     D setSysPrefix    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setSystemPrefix')
     D SysPrefix                       O   CLASS(*JAVA:'java.lang.String')
 
     D setServerNm     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setServerNm')
     D ServerNm                        O   CLASS(*JAVA:'java.lang.String')
 
     D setPortNum      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setPortNum')
     D PortNum                         O   CLASS(*JAVA:'java.lang.String')
 
     D setDBUser       PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setDBUser')
     D DBUser                          O   CLASS(*JAVA:'java.lang.String')
 
     D setPassword     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setPassword')
     D Password                        O   CLASS(*JAVA:'java.lang.String')
 
     D setDBName       PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.+
     D                                     info.CustomerMessageInfo':
     D                                     'setDBName')
     D DBName                          O   CLASS(*JAVA:'java.lang.String')
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D PZSnum          S              6  0
     D PZSerr          S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Work Variable
     D WSendStatus     S             10I 0
     D WError          S              1A   INZ('N')
     D WDateF          S             10A
     D WJstring        S               O   CLASS(*JAVA:'java.lang.String')
     D WJstringA4      S               O   CLASS(*JAVA:'java.lang.String')
     D                                     DIM(4)
     D WJstringA10     S               O   CLASS(*JAVA:'java.lang.String')
     D                                     DIM(10)
     D Widx            S              2S 0
     D WKYCDBName      S            200
     D WKYCServerName  S            200
     D WKYCPassword    S            200
     D WKYCPortNumber  S            200
     D WKYCDBUser      S            200
     D WDtlPrintFlg    S              1A   INZ('N')
     D WFirst          S              1A   INZ('N')
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D PRetCode        S              7A
                                                                                              CSD101
     D PReturnCode     S              7A                                                      CSD101
     D PAction         S              1A                                                      CSD101
     D PValidList      S             10A   INZ('SDINTFVL')                                    CSD101
     D PLibrary        S             10A                                                      CSD101
     D PIDName         S            100A                                                      CSD101
     D PPass1          S            128A                                                      CSD101
     D PDescr          S           1000A                                                      CSD101
 
      ** Entry Parameter
     D PICCOB          S              1
 
      ** Parameters for AOSVALR0
     D PRtnCode        S              7
     D PSysK1          S             20
     D PSysV1          S            200
     D PSysK2          S             20
     D PSysV2          S            200
     D PSysK3          S             20
     D PSysV3          S            200
     D PSysK4          S             20
     D PSysV4          S            200
     D PSysK5          S             20
     D PSysV5          S            200
     D PSysK6          S             20
     D PSysV6          S            200
     D PSysK7          S             20
     D PSysV7          S            200
     D PSysK8          S             20
     D PSysV8          S            200
     D PSysK9          S             20
     D PSysV9          S            200
     D PSysK10         S             20
     D PSysV10         S            200
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRInit
 
      ** Read and process all records from message to compliance watch file
 
     C     *LOVAL        SETLL     SDCWMGL0
     C                   READ      SDCWMGL0
     C                   DOW       NOT %EOF(SDCWMGL0)
 
      ** Execute sub-routine that will call the startKYCInterface
 
     C                   EXSR      SRSend
 
      ** Execute sub-routine that will check the status of sending
 
     C                   EXSR      SRCheck
 
     C                   READ      SDCWMGL0
     C                   ENDDO
 
      ** If called from COB
 
     C                   IF        PICCOB = 'C'
     C                   EXSR      SRPrtTrailRpt
     C                   ENDIF
 
      ** End of program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSend   - Subroutine to send the message to compliance       *
      *            watch thry java method startKYCInterface           *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRSetCMI                                               *
      *                                                               *
      *****************************************************************
 
     C     SRSend        BEGSR
 
     C                   EVAL      CMIObject = createCMI()
 
     C                   EXSR      SRSetCMI
 
     C                   EVAL      WSendStatus = 0
     C                   EVAL      WSendStatus =
     C                                          strKYCIntrf(CMIobject)
 
      ** If errors encountered due to failed connection.
     C                   IF        WSendStatus <> 0
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCheck - Subroutine to check the status of sending message   *
      *           to compliance watch. If sending is succesful,       *
      *           delete record from Messate to Compliance watch file.*
      *           If not, end the program if called from I/C else     *
      *           generate a report.                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRDeleteMsg, SRPrtExcptRpt                             *
      *                                                               *
      *****************************************************************
 
     C     SRCheck       BEGSR
 
     C                   IF        WError = 'N'
     C                   EXSR      SRDeleteMsg
     C                   ELSE
 
     C                   IF        PICCOB = 'C'
     C                   EXSR      SRPrtExcptRpt
     C                   ELSE
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrtExcptRpt - Subroutine to print customer which failed     *
      *           to be sent.                                         *
      *                                                               *
      * Called by: SRCheck                                            *
      *                                                               *
      * Calls: SRChkLine                                              *
      *                                                               *
      *****************************************************************
 
     C     SRPrtExcptRpt BEGSR
 
      ** Check for overflow
     C                   EVAL      RqdLn1 = 2
     C                   EXSR      SRChkLine
     C
     C                   EVAL      RRCUST = %subst(CWCNUM:4:6)
     C                   WRITE     DETAIL1
     C                   IF        WDtlPrintFlg   = 'N'
     C                   EVAL      WDtlPrintFlg   = 'Y'
     C                   ENDIF
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrtTrailRpt - Write Trail report                           *
      *                                                               *
      *****************************************************************
 
     C     SRPrtTrailRpt BEGSR
 
      ** Print AU if no details to be printed, else print trailer
     C                   IF        WDtlPrintFlg = 'N'
     C                   EXSR      SRPrtAuditRpt
     C                   ElSE
     C                   EVAL      RqdLn1 = 4
     C                   EXSR      SRChkLine
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrtAuditRpt - Write audit report                           *
      *                                                               *
      *****************************************************************
 
     C     SRPrtAuditRpt BEGSR
 
     C                   OPEN      SD000052AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      PZSnum = PSFNum2
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       PEnty
     C                   PARM                    PSFile2
     C                   PARM                    PZSnum
     C                   PARM      *Blank        PZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkLine - Checks for printer file overflow condition         *
      *                                                               *
      * Called by: SRPrtExcptRpt                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRChkLine     BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                             OR WFirst  = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst  = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDeleteMsg - Subroutine to delete record in Message to       *
      *           to Compliance watch file upon succesful send.       *
      *                                                               *
      * Called by: SRCheck                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDeleteMsg   BEGSR
 
     C                   DELETE    SDCWMGL0
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetCMI  - Subroutine to set CustomerMessageInfo fields      *
      *                                                               *
      * Called by: SRSend                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSetCMI      BEGSR
 
     C                   IF        %subst(CWCNUM:4:6) <> *BLANKS
     C                   EVAL      WJstring = makestr(%subst(CWCNUM:4:6))
     C                   CALLP     setCustNumber(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCNA1 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWCNA1))
     C                   CALLP     addAddress(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWCNA2 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWCNA2))
     C                   CALLP     addAddress(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWCNA3 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWCNA4))
     C                   CALLP     addAddress(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWCNA4 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWCNA4))
     C                   CALLP     addAddress(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCRNM <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCRNM)
     C                   CALLP     setReportName(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWPAIN <> *BLANKS
     C                   EVAL      WJstring = makestr(CWPAIN)
     C                   CALLP     setParentInd(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCNCZ <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCNCZ)
     C                   CALLP     setCtryCitizen(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWBRCD <> *BLANKS
     C                   EVAL      WJstring = makestr(CWBRCD)
     C                   CALLP     setBrchCode(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCOLC <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCOLC)
     C                   CALLP     setCtryDom(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWBSIN <> *BLANKS
     C                   EVAL      WJstring = makestr(CWBSIN)
     C                   CALLP     setBrchInd(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWBNBI <> *BLANKS
     C                   EVAL      WJstring = makestr(CWBNBI)
     C                   CALLP     setBankInd(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWDOIC <> *BLANKS
     C                             AND CWDOIC <> '0'
     C                   EVAL      WDateF   = %subst(CWDOIC:1:4) + '-' +
     C                                        %subst(CWDOIC:5:2) + '-' +
     C                                        %subst(CWDOIC:7:2)
     C                   EVAL      WJstring = makestr(WDateF)
     C                   CALLP     setDatFstCont(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWLINC <> *BLANKS
     C                   EVAL      WJstring = makestr(CWLINC)
     C                   CALLP     setInstCode(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCTNB <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCTNB)
     C                   CALLP     setTelephone(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWLICD <> *BLANKS
     C                   EVAL      WJstring = makestr(CWLICD)
     C                   CALLP     setIndustry(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWTAIN <> *BLANKS
     C                   EVAL      WJstring = makestr(CWTAIN)
     C                   CALLP     setAccHldTyp(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCSTY <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCSTY)
     C                   CALLP     setCustType(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCGRP <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCGRP)
     C                   CALLP     setRtlCustGrp(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWTXA1 <> *BLANKS
     C                   EVAL      WJstring = makestr(CWTXA1)
     C                   CALLP     setTelexAdd(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCRPC <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCRPC)
     C                   CALLP     setCorpCust(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWFXNB <> *BLANKS
     C                   EVAL      WJstring = makestr(CWFXNB)
     C                   CALLP     setFaxNum(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWIDNO <> *BLANKS
     C                   EVAL      WJstring = makestr(CWIDNO)
     C                   CALLP     setIdentityNum(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWTXNB <> *BLANKS
     C                   EVAL      WJstring = makestr(CWTXNB)
     C                   CALLP     setTelexNum(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWDOBH <> *BLANKS
     C                             AND CWDOBH <> '0'
     C                   EVAL      WDateF   = %subst(CWDOBH:1:4) + '-' +
     C                                        %subst(CWDOBH:5:2) + '-' +
     C                                        %subst(CWDOBH:7:2)
     C                   EVAL      WJstring = makestr(WDateF)
     C                   CALLP     setDOB(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWDOLV <> *BLANKS
     C                             AND CWDOLV <> '0'
     C                   EVAL      WDateF   = %subst(CWDOLV:1:4) + '-' +
     C                                        %subst(CWDOLV:5:2) + '-' +
     C                                        %subst(CWDOLV:7:2)
     C                   EVAL      WJstring = makestr(WDateF)
     C                   CALLP     setDatLstVisit(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWMDTL <> *BLANKS
     C                   EVAL      WJstring = makestr(CWMDTL)
     C                   CALLP     setMailDtl(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWAOA1 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWAOA1))
     C                   CALLP     addAcctOwnAdd(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWAOA2 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWAOA2))
     C                   CALLP     addAcctOwnAdd(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWAOA3 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWAOA4))
     C                   CALLP     addAcctOwnAdd(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWAOA4 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWAOA4))
     C                   CALLP     addAcctOwnAdd(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWTINN <> *BLANKS
     C                   EVAL      WJstring = makestr(CWTINN)
     C                   CALLP     setTinNum(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWTWBH <> *BLANKS
     C                   EVAL      WJstring = makestr(CWTWBH)
     C                   CALLP     setBirthTown(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCTBH <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCTBH)
     C                   CALLP     setBirthCtry(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWCRRT <> *BLANKS
     C                   EVAL      WJstring = makestr(CWCRRT)
     C                   CALLP     setCredRating(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWICNM <> *BLANKS
     C                   EVAL      WJstring = makestr(CWICNM)
     C                   CALLP     setIcNum(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWPASN <> *BLANKS
     C                   EVAL      WJstring = makestr(CWPASN)
     C                   CALLP     setPassNum(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWASCL <> *BLANKS
     C                   EVAL      WJstring = makestr(CWASCL)
     C                   CALLP     setAssetClass(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWFL01 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL01))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL02 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL02))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL03 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL03))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL04 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL04))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL05 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL05))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL06 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL06))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL07 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL07))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL08 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL08))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL09 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL09))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
     C                   IF        CWFL10 <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWFL10))
     C                   CALLP     addAddlCustFld(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        CWSYPX <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(CWSYPX))
     C                   CALLP     setSysPrefix(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        WKYCServerName <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(WKYCServerName))
     C                   CALLP     setServerNm(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        WKYCPortNumber <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(WKYCPortNumber))
     C                   CALLP     setPortNum(CMIobject:WJstring)
     C                   ENDIF
 
     C                   IF        WKYCDBUser <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(WKYCDBUser))
     C                   CALLP     setDBUser(CMIobject:WJstring)
     C                   ENDIF
 
     C**********         IF        WKYCPassword <> *BLANKS                                    CSD101
     C                   IF        WKYCDBUser <> *BLANKS                                      CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PIDName = 'COMPLKYC_' +  WKYCDBUser                        CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM      *Blanks       PPass1                                       CSD101
     C                   PARM      *Blanks       PDescr                                       CSD101
                                                                                              CSD101
     C                   IF        PReturnCode = *Blanks                                      CSD101
     C                   EVAL      WKYCPassword = PPass1                                      CSD101
     C                   EVAL      WJstring = makestr(%trim(WKYCPassword))
     C                   CALLP     setPassword(CMIobject:WJstring)
     C                   ENDIF                                                                CSD101
     C                   ENDIF
 
     C                   IF        WKYCDBName <> *BLANKS
     C                   EVAL      WJstring = makestr(%trim(WKYCDBName))
     C                   CALLP     setDBName(CMIobject:WJstring)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit  - Initialisation                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      PZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       PEnty
     C                   PARM                    PSFile1
     C                   PARM                    PZSnum
     C                   PARM      *Blank        PZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSerr = 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   EVAL      RqdLn1   = 0
     C                   EVAL      DifLn1   = 0
     C                   EVAL      PrtLn1   = 0
     C                   EVAL      WError   = 'N'
     C                   EVAL      WFirst   = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PICCOB
 
      ** Get KYC Database Name, Server Name, Port, User and Password
 
     C                   EVAL      PSysK1 = 'KYCDatabaseName     '
     C                   EVAL      PSysK2 = 'KYCServerName       '
     C                   EVAL      PSysK3 = 'KYCPortNumber       '
     C                   EVAL      PSysK4 = 'KYCDBUser           '
     C**********         EVAL      PSysK5 = 'KYCPassword         '                            CSD101
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PSysK1
     C                   PARM                    PSysV1
     C                   PARM                    PSysK2
     C                   PARM                    PSysV2
     C                   PARM                    PSysK3
     C                   PARM                    PSysV3
     C                   PARM                    PSysK4
     C                   PARM                    PSysV4
     C                   PARM                    PSysK5
     C                   PARM                    PSysV5
     C                   PARM                    PSysK6
     C                   PARM                    PSysV6
     C                   PARM                    PSysK7
     C                   PARM                    PSysV7
     C                   PARM                    PSysK8
     C                   PARM                    PSysV8
     C                   PARM                    PSysK9
     C                   PARM                    PSysV9
     C                   PARM                    PSysK10
     C                   PARM                    PSysV10
 
     C                   IF        PRtnCode <> *BLANKS
     C                   IF        PSysV1 = '*NRF'
     C                   EVAL      DBKEY = PSysK1
     C                   ENDIF
     C                   IF        PSysV2 = '*NRF'
     C                   EVAL      DBKEY = PSysK2
     C                   ENDIF
     C                   IF        PSysV3 = '*NRF'
     C                   EVAL      DBKEY = PSysK3
     C                   ENDIF
     C                   IF        PSysV4 = '*NRF'
     C                   EVAL      DBKEY = PSysK4
     C                   ENDIF
     C**********         IF        PSysV5 = '*NRF'                                            CSD101
     C**********         EVAL      DBKEY = PSysK5                                             CSD101
     C**********         ENDIF                                                                CSD101
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   EVAL      WKYCDBName     = PSysV1
     C                   EVAL      WKYCServerName = PSysV2
     C                   EVAL      WKYCPortNumber = PSysV3
     C                   EVAL      WKYCDBUser     = PSysV4
     C**********         EVAL      WKYCPassword   = PSysV5                                    CSD101
                                                                                              CSD101
     C                   IN        SDSTAT                                                     CSD101
                                                                                              CSD101
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      PRetCode = '*ERROR'
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
