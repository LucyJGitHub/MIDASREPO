     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Watch List Compliance Initial Library List Setup')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000907 - Watch List Compliance Initial Library List Setup  *
      *                                                               *
      *  Function:  This program will perform compliance watch list   *
      *             setup of initial library list.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CSD083  *CREATE    Date 27May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')
 
     D Parm            DS          3200
     D OffSetB               361    364B 0
     D LibCountB             365    368B 0
 
     D Len             S              4B 0 INZ(3200)
 
     D OffLen          S              9  0
     D OffSet          S              9  0
     D InLibl          S           2750
     D Command         S           2764
 
      ** Error message format for retrieve jobd libl
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D APIRetC         S              1
     D MsgArrO         S           9999
     D SysID           S              2
     D Format          S             10
     D @RUN            S              1    INZ('N')
 
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Set up job description library list
 
     C                   CALL      'QWDRJOBD'                           9697
     C                   PARM                    Parm
     C                   PARM                    Len
     C                   PARM      'JOBD0100'    Format           10
     C                   PARM                    Jobd
     C                   PARM                    QUSEC
 
     C                   IF        QUSEI = 'CPF9801' OR
     C                             QUSEI = 'CPF9810'
     C                   EVAL      APIRetC = '0'
     C                   EVAL      MsgArrO = ':::Midas system job +
     C                             description not found:'
     C                   RETURN
     C                   ENDIF
 
     C                   IF        QUSEI = 'CPF9802' OR
     C                             QUSEI = 'CPF9820'
     C                   EVAL      APIRetC = '0'
     C                   EVAL      MsgArrO = ':::Not authorised to Midas +
     C                             system job description:'
     C                   RETURN
     C                   ENDIF
 
     C                   EVAL      OffSet = OffSetB + 1
     C                   EVAL      OffLen = LibCountB * 11
     C                   EVAL      InLibl = %SubSt(Parm:OffSet:OffLen)
     C                   EVAL      Command = ('CHGLIBL LIBL(' +
     C                             InLibl + ')')
 
     C                   CALL      'QCMDEXC'                              92
     C                   PARM                    Command
     C                   PARM      2764          Length           15 5
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      ****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    MsgArrO
     C                   PARM                    APIRetC
     C                   PARM                    SysID
 
     C                   EVAL      APIRetC = '1'
     C                   EVAL      System = SysID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**Calling Routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      APIRetC = '0'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
