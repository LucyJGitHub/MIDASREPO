     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('RE Stopped Cheques Validation Adoption Program')
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  RESTCQVL - RE Stopped Cheques Validation Adoption Program    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. MD038818           Date 30May16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSC041  *CREATE    Date 26Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD038818 - Serious Midas Error Occurs when authorizing       *
      *             Stopped Checque                                   *
      *           - Variable that hold the job details is too short   *
      *             to handle the library list                        *
      *  CSC041 - 4-Eyes Checking Gaps                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
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

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Entry Parameters
     D PACNT           S             34A
     D PREFN           S              3A
     D PFCHQ           S              8A
     D PTCHQ           S              8A
     D PRTCD           S              1A
     D PERMSG          S          32000A   VARYING

     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')

     D***Parm***         DS          1000                                        MD038818
     D Parm            DS          3200                                          MD038818
     D OffSetB               361    364B 0
     D LibCountB             365    368B 0

      ** If this Message array needs to increase, a separate parameter
      ** will need to be added
     D MsgArrOut       S           9999    INZ(*BLANKS)

     D OffLen          S              9  0
     D OffSet          S              9  0
     D InLibl          S           2750
     D Command         S           2764
     D Format          S             10
     D Length          S             15  5
     D***Len****         S              4B 0 INZ(1000)                          MD038818
     D Len             S              4B 0 INZ(3200)                            MD038818

      ** Error message format for retrieve JOBD *LIBL
     DQUSEC            DS
      *                                           Qus EC
     D QUSBPRV                 1      4B 0
      *                                           Bytes Provided
     D QUSBAVL                 5      8B 0
      *                                           Bytes Available
     D QUSEI                   9     15
      *                                           Exception Id
     D QUSERVED               16     16
      *                                           Reserved
     D QUSExcData             17     46
      *                                           Varying length
      *                                           field Exception Data

      ** +--- Start of main processing -------------------------------+

     C     *ENTRY        PLIST
     C                   PARM                    PACNT
     C                   PARM                    PREFN
     C                   PARM                    PFCHQ
     C                   PARM                    PTCHQ
     C                   PARM                    PRTCD
     C                   PARM                    PERMSG

     C                   EVAL      PRTCD = '1'
      *
      ** Set up job description library list
      *
     C                   CALL      'QWDRJOBD'                           9697
     C                   PARM                    PARM
     C                   PARM                    Len
     C                   PARM      'JOBD0100'    Format
     C                   PARM                    Jobd
     C                   PARM                    QUSEC
      *
     C                   IF        QUSEI = 'CPF9801' OR
     C                             QUSEI = 'CPF9810'
     C                   EVAL      PRTCD = '0'
     C                   EVAL      PERMSG = ':::Midas system job +
     C                             description not found:'
     C                   RETURN
     C                   ENDIF
      *
     C                   IF        QUSEI = 'CPF9802' OR
     C                             QUSEI = 'CPF9820'
     C                   EVAL      PRTCD = '0'
     C                   EVAL      PERMSG = ':::Not authorised to +
     C                             Midas system job description:'
     C                   RETURN
     C                   ENDIF
      *
     C                   EVAL      OffSet = OffSetB + 1
     C                   EVAL      OffLen = LibCountB * 11
     C                   EVAL      InLibl = %SUBST(Parm:OffSet:OffLen)
     C                   EVAL      Command = ('CHGLIBL LIBL(' +
     C                             InLibl + ')')

     C                   CALL      'QCMDEXC'                              92
     C                   PARM                    Command
     C                   PARM      2764          Length

     C                   CALL      'REC004245'   ParamStr

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation subroutine                            *
      *                                                               *
      * Called by: Automatically called upon program execution        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C                   IN        SDSTAT
     C                   EVAL      System = LIBR

      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------

     C     ParamStr      PLIST
     C                   PARM                    PACNT
     C                   PARM                    PREFN
     C                   PARM                    PFCHQ
     C                   PARM                    PTCHQ
     C                   PARM                    PRTCD
     C                   PARM                    PERMSG

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program exception error routine                       *
      *                                                               *
      * Called by: Automatically called by error handler              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound CALL to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE

     C                   EVAL      PRTCD = '0'
     C                   EVAL      PERMSG = ':::System error has +
     C                             occurred in Midas. Please inform +
     C                             a Midas System operator:'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
