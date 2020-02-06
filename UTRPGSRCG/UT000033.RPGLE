      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Common Validation List functions')            *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000033 - Common Validation List functions                  *
      *                                                               *
      *  Function:  This program wraps common VLDL object API         *
      *             functions                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT007             Date 10Dec10               *
      *                 BUG27989 *CREATE   Date 08Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT007 - Make utility file-driven.                           *
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
      *
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
      * "Entry ID" information.
     D EIDINFO         DS
      * Length of entry ID.
     D  EIDLen                 1      4B 0 INZ(10)
      * CCSID of entry ID.
     D  EIDccsid               5      8B 0 INZ(9)
      * Entry ID.
      *D**EIDdata****************9****264*                                                    CUT007
     D  EIDdata                9    108                                                       CUT007
      *
      * "Data to encrypt" information.
     D EEDINFO         DS
      * Length of encyption data.
     D  EEDLen                 1      4B 0 INZ(10)
      * CCSID of encryption data.
     D  EEDccsid               5      8B 0 INZ(9)
      *                                    Entry ID
      *D**EEDdata****************9****264*                                                    CUT007
     D  EEDdata                9    608                                                       CUT007
      *
      * "Entry data" information.
     D EDTINFO         DS
      * Length of data.
     D  EDTLen                 1      4B 0 INZ(50)
      * CCSID of data.
     D  EDTccsid               5      8B 0 INZ(9)
      * Data.
      *D**EDTdata****************9****264*                                                    CUT007
     D  EDTdata                9   1008                                                       CUT007
      *
      * "Attribute" information.
     D EATINFO         DS
      * Number of attributes.
     D  EATNbr                 1      4B 0 INZ(1)
      * Length of attribute entry.
     D  ATTELen                5      8B 0 INZ(64)
      * Attribute location = vldl.
     D  ATTloc                 9     12B 0 INZ(0)
      * Attribute type = system defined.
     D  ATTtyp                13     16B 0 INZ(0)
      * Displacement to attribute ID.
     D  ATTdis1               17     20B 0 INZ(28)
      * Length of attribute ID.
     D  ATTlen1               21     24B 0 INZ(14)
      * Displacement to attribute data.
     D  ATTdis2               25     28B 0 INZ(42)
      * Length of attribute data.
     D  ATTlen2               29     32B 0 INZ(22)
      * Attribute ID.
     D  ATTID                 33     46    INZ('QsyEncryptData')
      * CCSID of attribute.
     D  ATTccsid              47     50B 0 INZ(-1)
      * Length of attribute.
     D  ATTlen                51     54B 0 INZ(1)
      * Reserved (8 char).
     D  ATTrsv                55     62
      * Attribute value.
      *  1 = data returned on find
     D  ATTval                63     63    INZ('1')
     D                        64     68
      *
      * Layouts for finding a validation list entry.
      *  1-"Entry ID" information.
     D FEIDINFO        DS
      * Length of entry ID.
     D  FEIDLen                1      4B 0 INZ(10)
      * CCSID of entry ID.
     D  FEIDccsid              5      8B 0 INZ(9)
      * Entry ID.
      *D**FEIDdata***************9****264*                                                    CUT007
     D  FEIDdata               9    108                                                       CUT007
      *
      * 2-"Attribute" information.
     D FEATINFO        DS
      * Number of attributes
      *  "Attribute entry"
     D  FEATNbr                1      4B 0 INZ(0)
      * Length of attribute entry (64).
     D  FATTELen               5      8B 0 INZ(0)
      * Attribute location = vldl.
     D  FATTloc                9     12B 0 INZ(0)
      * Attribute type = system defined.
     D  FATTtyp               13     16B 0 INZ(0)
      * Displacement to attribute ID.
     D  FATTdis1              17     20B 0 INZ(24)
      * Length of attribute ID.
     D  FATTlen1              21     24B 0 INZ(14)
      * Bytes provided for attribute.
     D  FATTbyte              25     28B 0 INZ(0)
      * Attribute ID.
     D  FATTID                29     42    INZ('QsyEncryptData')
      *
      * 3-"Return Entry" information.
     D FERTINFO        DS
      * Length of entry ID.
     D  FERTLen                1      4B 0 INZ(10)
      * CCSID of entry ID.
     D  FERTccsid              5      8B 0 INZ(9)
      * Entry ID.
     D  FERTdata               9    108
      * Length of encrypted data.
     D  FERTYLen             109    112B 0 INZ(10)
      * CCSID of encrypted data.
     D  FERTYccsid           113    116B 0 INZ(9)
      * Encrypted data.
     D  FERTYdata            117    716
      * Length of data.
     D  FERTDLen             717    720B 0 INZ(20)
      * CCSID of data.
     D  FERTDccsid           721    724B 0 INZ(9)
      * Entry data.
     D  FERTDdata            725   1724
      * Reserved.
     D  FERTDrsv            1725   1744
      *
      * 4-"Return Attribute" information.
     D FEATRINFO       DS
      * Length of attribute entry.
     D  FATTRLen               1      4B 0
      * Bytes returned.
     D  FATTRbyte              5      8B 0
      * Bytes available.
     D  FATTRavai              9     12B 0
      * Length of attribute.
     D  FATTRlen1             13     16B 0
      * CCSID of attribute.
     D  FATTRccsid            17     20B 0
      * Attribute value.
     D  FATTRval              21     44
      *
     DQUSEC            DS
      * Bytes Provided.
     D QUSBPRV                       10I 0 INZ(%SIZE(QUSEC))
      * Bytes Available.
     D QUSBAVL                       10I 0 INZ(*ZEROS)
      * Exception ID.
     D QUSEI                          7
      * Reserved.
     D                                1
      * Message data.
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
      * Constants used to identify action code to be performed.
     D Insert          C                   CONST('A')
     D Modify          C                   CONST('M')
     D Delete          C                   CONST('D')
     D Find            C                   CONST('F')
      *
      * Validation list variables.
     D VLDL            DS                  ALIGN
     D   ValidList                   10A
     D   Library                     10A
      *
      * Entry parameters.
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
      *D*PuserName*******S************256A*                                                   CUT007
      *D*PPass1**********S************256A*                                                   CUT007
      *D*PPass2**********S************256A*                                                   CUT007
      *D*PDescr**********S*************50A*                                                   CUT007
     D PIDName         S            100A                                                      CUT007
     D PPass1          S            600A                                                      CUT007
     D PPass2          S            600A                                                      CUT007
     D PDescr          S           1000A                                                      CUT007
      *
      *
      /EJECT
      *****************************************************************
      ** MAIN - Processing
      *****************************************************************
      *
      * Based on the action code passed to this module, perform Add, Edit, Delete
      *  or View a validation list entry.
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
      *
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
      * Set Entry ID information.
     C**********         EVAL      EIDData = PUserName                                        CUT007
     C**********         EVAL      EIDLen  = %LEN(%TRIMR(PUsername))                          CUT007
     C                   EVAL      EIDData = PIDName                                          CUT007
     C                   EVAL      EIDLen  = %LEN(%TRIMR(PIDName))                            CUT007
      *
      * Set data to encrypt information (password).
     C                   EVAL      EEDData = PPass1
     C                   EVAL      EEDLen  = %LEN(%TRIMR(PPass1))
      *
      * Set data (description).
     C**********         EVAL      UserData= PDescr                                           CUT007
     C**********         EVAL      EDTData  = UserData                                        CUT007
     C                   EVAL      EDTData  = PDescr                                          CUT007
     C                   EVAL      EDTLen  = %LEN(%TRIMR(PDescr))                             CUT007
      *
      * Add validation list entry.
     C                   EVAL      QUSEI = *BLANKS
     C                   CALLP     InsertAPI(VLDL:EIDINFO:EEDINFO:EDTINFO:
     C                             EATINFO:QUSEC)
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   ENDIF
      *
     C     SrInsertE     ENDSR
      *
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
      * Set Entry ID information.
     C**********         EVAL      EIDData = PUserName                                        CUT007
     C**********         EVAL      EIDLen  = %LEN(%TRIMR(PUsername))                          CUT007
     C                   EVAL      EIDData = PIDName                                          CUT007
     C                   EVAL      EIDLen  = %LEN(%TRIMR(PIDName))                            CUT007
      *
      * Set data to encrypt information (password).
     C                   EVAL      EEDData = PPass1
     C                   IF        PPass2 <> *BLANKS
     C                   EVAL      EEDData = PPass2
     C                   ELSE
     C                   EVAL      EEDData = PPass1
     C                   ENDIF
     C                   EVAL      EEDLen  = %LEN(%TRIMR(EEDData))
      *
      * Set data (description).
     C                   EVAL      EDTData = PDescr
     C                   EVAL      EDTLen  = %LEN(%TRIMR(PDescr))                             CUT007
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
     C     SrModifyE     ENDSR
      *
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
      * Set Entry ID information.
     C**********         EVAL      EIDData = PUserName                                        CUT007
     C**********         EVAL      EIDLen  = %LEN(%TRIMR(PUsername))                          CUT007
     C                   EVAL      EIDData = PIDName                                          CUT007
     C                   EVAL      EIDLen  = %LEN(%TRIMR(PIDName))                            CUT007
      *
      * Set data to encrypt information (password).
     C                   EVAL      EEDData = PPass1
     C                   EVAL      EEDLen  = %LEN(%TRIMR(PPass1))
      *
      * Set Data (Description)
     C**********         EVAL      UserData= PDescr                                           CUT007
     C**********         EVAL      EDTData  = UserData                                        CUT007
     C                   EVAL      EDTData  = PDescr                                          CUT007
     C                   EVAL      EDTLen  = %LEN(%TRIMR(PDescr))                             CUT007
      *
      * Remove validation list entry.
     C                   EVAL      QUSEI = *BLANKS
     C                   CALLP     RemoveAPI(VLDL:EIDINFO:QUSEC)
      *
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   ENDIF
      *
     C     SrDeleteE     ENDSR
      *
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
      * Set Entry ID information.
     C**********         EVAL      FEIDdata= PUserName                                        CUT007
     C**********         EVAL      FEIDlen = %LEN(%TRIMR(PUserName))                          CUT007
     C                   EVAL      FEIDdata= PIDName                                          CUT007
     C                   EVAL      FEIDlen = %LEN(%TRIMR(PIDName))                            CUT007
     C                   EVAL      QUSEI = *BLANKS
     C                   CALLP     FindAPI(VLDL:FEIDINFO:FEATINFO:FERTINFO:
     C                                    FEATRINFO:QUSEC)
     C                   IF        QUSEI <> *BLANKS
     C                   EVAL      PReturnCode = QUSEI
     C                   ELSE
     C                   EVAL      PReturnCode = *BLANKS
     C                   ENDIF
      *
      * Retrieve current password.
     C                   EVAL      PPass1 = %SUBST(FERTYData:1:FERTYLen)                      CUT007
     C**********         EVAL      PDescr = %SUBST(FERTDData:1:50)                            CUT007
     C                   EVAL      PDescr = %SUBST(FERTDData:1:1000)                          CUT007
      *
     C     SrFindE       ENDSR
      *
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
      * Parameters.
     C     *ENTRY        PLIST
      * Return code.
     C                   PARM                    PReturnCode
      * Action code ('A', 'M', 'D' or 'V').
     C                   PARM                    PAction
      * Validation list object.
     C                   PARM                    PValidList
      * Library where validation list object is created.
     C                   PARM                    PLibrary
      **ID*(256*character).*                                                                  CUT007
      * ID (100 character).                                                                   CUT007
     C**********         PARM                    PUserName                                    CUT007
     C                   PARM                    PIDName                                      CUT007
      ***Password*1*(256*character)*                                                          CUT007
      ** Password 1 (600 character)                                                           CUT007
     C                   PARM                    PPass1
      **Password*2*(256*character),*for*Edit*action*this*is*the*new*                          CUT007
      ***password.*Otherwise*set*this*to*blanks.*                                             CUT007
      * Password 2 (600 character), for Edit action this is the new                           CUT007
      *  password. Otherwise set this to blanks.                                              CUT007
     C                   PARM                    PPass2
     C                   PARM                    PDescr
      *
     C                   EVAL      ValidList = PValidList
     C                   EVAL      Library   = PLibrary
      *
     C     INZSRE        ENDSR
      *
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
