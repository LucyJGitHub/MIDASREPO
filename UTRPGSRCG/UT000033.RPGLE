      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Common Validation List Functions')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000033 - Common Validation List Functions                  *
      *                                                               *
      *  Function:  This program wraps common VLDL object API         *
      *             functions                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG27989*CREATE    Date 08Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27989 - HATS should run with/without LDAP                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInsert - Insert a Validation List Entry                    *
      *  SrModify - Modify a validation List Entry                    *
      *  SrDelete - Delete a Validation list Entry                    *
      *  SrFind - Find a Validation list Entry                        *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
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
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
      *
      ** API used for adding a validation list entry
     D InsertAPI       PR                  EXTPGM('QSYADVLE')
     D  theVLDL                            LIKE(VLDL)
     D  theEIDINFO                         LIKE(EIDINFO)
     D  theEEDINFO                         LIKE(EEDINFO)
     D  theEDTINFO                         LIKE(EDTINFO)
     D  theEATINFO                         LIKE(EATINFO)
     D  thequsec                           LIKE(QUSEC)
      *
      ** API used to find a validation list entry
     D FindAPI         PR                  EXTPGM('QSYFDVLE')
     D  theVldl                            LIKE(VLDL)
     D  theFEIDINFO                        LIKE(FEIDINFO)
     D  theFEATINFO                        LIKE(FEATINFO)
     D  theFERTINFO                        LIKE(FERTINFO)
     D  theFEATRINFO                       LIKE(FEATRINFO)
     D  thequsec                           LIKE(QUSEC)
      *
      ** API used for removing a validation list entry
     D RemoveAPI       PR                  EXTPGM('QSYRMVLE')
     D  theVldl                            LIKE(VLDL)
     D  theEIDINFO                         LIKE(EIDINFO)
     D  thequsec                           LIKE(qusec)
      *
      **  API used for changing a validation list entry
     D ModifyAPI       PR                  EXTPGM('QSYCHVLE')
     D  theVldl                            LIKE(VLDL)
     D  theEIDINFO                         LIKE(EIDINFO)
     D  theEEDINFO                         LIKE(EEDINFO)
     D  theEDTINFO                         LIKE(EDTINFO)
     D  theEATINFO                         LIKE(EATINFO)
     D  thequsec                           LIKE(QUSEC)
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** "Entry ID" information
     D EIDINFO         DS
      ** Length of entry ID
     D  EIDLen                 1      4B 0 INZ(10)
      ** CCSID of entry ID
     D  EIDccsid               5      8B 0 INZ(9)
      ** Entry ID
     D  EIDdata                9    264
      *
      ** "Data to encrypt" information
     D EEDINFO         DS
      ** Length of entry ID
     D  EEDLen                 1      4B 0 INZ(10)
      ** CCSID of entry ID
     D  EEDccsid               5      8B 0 INZ(9)
      *                                    Entry ID
     D  EEDdata                9     28
      *
      ** "Entry data" information
     D EDTINFO         DS
      ** Length of entry ID
     D  EDTLen                 1      4B 0 INZ(50)
      ** CCSID of entry ID
     D  EDTccsid               5      8B 0 INZ(9)
      ** Entry ID
     D  EDTdata                9     58
      *
      ** "Attribute" information
     D EATINFO         DS
      ** Number of attributes
     D  EATNbr                 1      4B 0 INZ(1)
      ** Length of attribute entry
     D  ATTELen                5      8B 0 INZ(64)
      ** Attribute location = vldl
     D  ATTloc                 9     12B 0 INZ(0)
      ** Attribute type = system defined
     D  ATTtyp                13     16B 0 INZ(0)
      ** Displacement to attribute ID
     D  ATTdis1               17     20B 0 INZ(28)
      ** Length of attribute ID
     D  ATTlen1               21     24B 0 INZ(14)
      ** Displacement to attribute data
     D  ATTdis2               25     28B 0 INZ(42)
      ** Length of attribute data
     D  ATTlen2               29     32B 0 INZ(22)
      ** Attribute ID
     D  ATTID                 33     46    INZ('QsyEncryptData')
      ** CCSID of attribute
     D  ATTccsid              47     50B 0 INZ(-1)
      ** Length of attribute
     D  ATTlen                51     54B 0 INZ(1)
      ** Reserved (8 char)
     D  ATTrsv                55     62
      **  Attribute value
      **                                       1 = data returned on find
     D  ATTval                63     63    INZ('1')
     D                        64     68
      *
      ** LAYOUTS FOR FINDING A VALIDATION LIST ENTRY
      *
      ** 1-"Entry ID" information
     D FEIDINFO        DS
      ** Length of entry ID
     D  FEIDLen                1      4B 0 INZ(10)
      ** CCSID of entry ID
     D  FEIDccsid              5      8B 0 INZ(9)
      ** Entry ID
     D  FEIDdata               9    264
      *
      ** 2-"Attribute" information
     D FEATINFO        DS
      ** Number of attributes
      ** "Attribute entry"
     D  FEATNbr                1      4B 0 INZ(0)
      ** Length of attribute entry (64)
     D  FATTELen               5      8B 0 INZ(0)
      ** Attribute location = vldl
     D  FATTloc                9     12B 0 INZ(0)
      ** Attribute type = system defined
     D  FATTtyp               13     16B 0 INZ(0)
      ** Displacement to attribute ID
     D  FATTdis1              17     20B 0 INZ(24)
      ** Length of attribute ID
     D  FATTlen1              21     24B 0 INZ(14)
      ** Bytes provided for attribute
     D  FATTbyte              25     28B 0 INZ(0)
      ** Attribute ID
     D  FATTID                29     42    INZ('QsyEncryptData')
      *
      ** 3-"Return Entry" information
     D FERTINFO        DS
      ** Length of entry ID
     D  FERTLen                1      4B 0 INZ(10)
      ** CCSID of entry ID
     D  FERTccsid              5      8B 0 INZ(9)
      ** Entry ID
     D  FERTdata               9    108
      ** Length of encrypted data
     D  FERTYLen             109    112B 0 INZ(10)
      ** CCSID of encrypted data
     D  FERTYccsid           113    116B 0 INZ(9)
      ** encrypted data
     D  FERTYdata            117    716
      ** Length of data
     D  FERTDLen             717    720B 0 INZ(20)
      ** CCSID of data
     D  FERTDccsid           721    724B 0 INZ(9)
      ** entry data
     D  FERTDdata            725   1724
      ** reserved
     D  FERTDrsv            1725   1744
      *
      ** 4-"Return Attribute" information
     D FEATRINFO       DS
      ** Length of attribute entry
     D  FATTRLen               1      4B 0
      ** Bytes returned
     D  FATTRbyte              5      8B 0
      ** Bytes available
     D  FATTRavai              9     12B 0
      ** Length of attribute
     D  FATTRlen1             13     16B 0
      ** CCSID of attribute
     D  FATTRccsid            17     20B 0
      ** Attribute value
     D  FATTRval              21     44
      *
     DQUSEC            DS
      ** Bytes Provided
     D QUSBPRV                       10I 0 INZ(%SIZE(QUSEC))
      ** Bytes Available
     D QUSBAVL                       10I 0 INZ(*ZEROS)
      ** Exception ID
     D QUSEI                          7
      ** Reserved
     D                                1
      ** Message Data
     D MSDDATA                      500
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1A
     D UserData        S             50A
      *
      ** Constants used to identify action code to be performed
     D Insert          C                   CONST('A')
     D Modify          C                   CONST('M')
     D Delete          C                   CONST('D')
     D Find            C                   CONST('F')
      *
      ** Validation list variables
     D VLDL            DS                  ALIGN
     D   ValidList                   10A
     D   Library                     10A
      *
      ** Entry parameters
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D PuserName       S            256A
     D PPass1          S            256A
     D PPass2          S            256A
     D PDescr          S             50A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN - Processing
      *****************************************************************
      *
      ** Based on the action code passed to this module,
      ** perform Add, Edit, Delete or View a validation
      ** list entry
      *
     C                   SELECT
     C                   WHEN      PAction = Insert
     C                   EXSR      SrInsert
     C                   WHEN      PAction = Modify
     C                   EXSR      SrModify
     C                   WHEN      PAction = Delete
     C                   EXSR      SrDelete
     C                   WHEN      PAction = Find
     C                   EXSR      SrFind
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInsert - Insert a Validation List Entry                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: InsertAPI                                             *
      *                                                               *
      *****************************************************************
     C     SrInsert      BEGSR
      *
      ** Set Entry ID information
     C                   EVAL      EIDData = PUserName
     C                   EVAL      EIDLen  = %LEN(%TRIMR(PUsername))
      *
      ** Set Data to Encrypt Information (Password)
     C                   EVAL      EEDData = PPass1
     C                   EVAL      EEDLen  = %LEN(%TRIMR(PPass1))
      *
      ** Set Data (Description)
     C                   EVAL      UserData= PDescr
     C                   EVAL      EDTData  = UserData
      *
      ** Add validation list entry
     C                   EVAL      QUSEI = *BLANKS
     C                   CALLP     InsertAPI(VLDL:EIDINFO:EEDINFO:EDTINFO:
     C                             EATINFO:QUSEC)
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrModify - Modify a Validation List Entry                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: ModifyAPI                                             *
      *                                                               *
      *****************************************************************
     C     SrModify      BEGSR
      *
      ** Set Entry ID information
     C                   EVAL      EIDData = PUserName
     C                   EVAL      EIDLen  = %LEN(%TRIMR(PUsername))
      *
      ** Set Data to Encrypt Information (Password)
     C                   EVAL      EEDData = PPass1
     C                   IF        PPass2 <> *BLANKS
     C                   EVAL      EEDData = PPass2
     C                   ELSE
     C                   EVAL      EEDData = PPass1
     C                   ENDIF
     C                   EVAL      EEDLen  = %LEN(%TRIMR(EEDData))
      *
      ** Set Data (Description)
     C                   EVAL      EDTData = PDescr
      *
     C                   EVAL      QUSEI = *BLANKS
      *
     C                   CALLP     ModifyAPI(VLDL:EIDINFO:EEDINFO:EDTINFO:
     C                             EATINFO:QUSEC)
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelete - Delete a Validation list Entry                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: DeleteAPI                                             *
      *                                                               *
      *****************************************************************
     C     SrDelete      BEGSR
      *
      ** Set Entry ID information
     C                   EVAL      EIDData = PUserName
     C                   EVAL      EIDLen  = %LEN(%TRIMR(PUsername))
      *
      ** Set Data to Encrypt Information (Password)
     C                   EVAL      EEDData = PPass1
     C                   EVAL      EEDLen  = %LEN(%TRIMR(PPass1))
      *
      ** Set Data (Description)
     C                   EVAL      UserData= PDescr
     C                   EVAL      EDTData  = UserData
      *
      ** Remove validation list entry
     C                   EVAL      QUSEI = *BLANKS
     C                   CALLP     RemoveAPI(VLDL:EIDINFO:QUSEC)
      *
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFind - Find a Validation list Entry                        *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: FindAPI                                               *
      *                                                               *
      *****************************************************************
     C     SrFind        BEGSR
      *
      ** Set Entry ID information
     C                   EVAL      FEIDdata= PUserName
     C                   EVAL      FEIDlen = %LEN(%TRIMR(PUserName))
     C                   EVAL      QUSEI = *BLANKS
     C                   CALLP     FindAPI(VLDL:FEIDINFO:FEATINFO:FERTINFO:
     C                                    FEATRINFO:QUSEC)
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   ENDIF
      *
      ** Retrieve current password
     C                   EVAL      PPass1 = %SUBST(FERTYData:1:FERTYLen)
     C                   EVAL      PDescr = %SUBST(FERTDData:1:50)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Return code
     C                   PARM                    PReturnCode
      *
      ** Action code ('A', 'M', 'D' or 'V')
     C                   PARM                    PAction
      *
      ** Validation list object
     C                   PARM                    PValidList
      *
      ** Library where validation list object is created
     C                   PARM                    PLibrary
      *
      ** User Name (256 character)
     C                   PARM                    PUserName
      *
      ** Password 1 (256 character)
     C                   PARM                    PPass1
      *
      ** Password 2 (256 character), for Edit action this is the
      ** new password. Otherwise set this to blanks
     C                   PARM                    PPass2
     C                   PARM                    PDescr
      *
     C                   EVAL      ValidList = PValidList
     C                   EVAL      Library   = PLibrary
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2010
