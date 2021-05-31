     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Cust/Aut Holders Validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUAHVAL - SD Customer/Authority Holders Details Validation *
      *                                                               *
      *  Function:  This module validates the Customer/Authority      *
      *             Holders Details function                          *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD050526           Date 27Oct20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL132             Date 15Mar13               *
      *                 AR855391           Date 27Oct11               *
      *                 CSD091             Date 04Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25850           Date 03Sep09               *
      *                 BUG22521           Date 25Mar09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050526 - Maintain Customers tab Authority Holders Link and *
      *             Details by Country of Tax code not shown in red   *
      *             in case of errors                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *  CSD091 - Overrideable Errors Configurability Enabler Phase 2 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25850 - Non-account holder error connection to customer   *
      *  BUG22521 - Cannot navigate to Link Types Maintenance         *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRAuthVal  - Validate Authority Holder                       *
      *  SRLTypVal  - Validate Link Type                              *
      *  SRPrGrpVal - Validate Product Groups                         *
      *  SRATypVal  - Validate Authority Type                         *
      *  SRRecCheck - Check if Record already in file                 *
      *  SRSetupVali- Set up Valid field values                       *
      *  SRResetErrs - Reset error information that is received back  *
      *                from each validation module                    *
      *  SRUpdatErrs - Update error information with that received    *
      *                back from each validation module               *
      *                                                               *
      *  *INZSR - Program initialization routine                      *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Authority types
     FSDAUTPL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Authority holders
     FSDCUAHL1  IF   E           K DISK    INFSR(*PSSR)
      *                                                                                     BUG22521
      ** Link types                                                                         BUG22521
     FSDLINKL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG22521
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      ********************************************************************
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
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
      ** Customer to Authority Holder Link Screen File
     D CustAuth        DS
     D DDAUTH                  1     10
     D DDLTYP                 11     12
     D DDPRG1                 13     14
     D DDPRG2                 15     16
     D DDPRG3                 17     18
     D DDPRG4                 19     20
     D DDTYPA                 21     22
     D DDCINT                 23     23                                                       CGL132
     D DDPCNT                 24     26                                                       CGL132
      *
      ** Midas Customer to Authority Holder Link
     D SDVCUAH       E DS                  EXTNAME(SDVCUAHPD)
      *
      ** Midas SD Customer details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access Programs, long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                     BUG25850
      ** Third DS for Access Programs, long Data Structure                                  BUG25850
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG25850
      *
      ** Midas SD Non-account Holders
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *
     D OKCustAuth      DS
     D AuthOk                  1      1
     D LTypOk                  2      2
     D PrGp1Ok                 3      3
     D PrGp2Ok                 4      4
     D PrGp3Ok                 5      5
     D PrGp4Ok                 6      6
     D ATypOk                  7      7
     D CIntOk                  8      8                                                       CGL132
     D CPerOk                  9      9                                                       CGL132
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtCd           S              7A
     D PKySt           S              7A
     D POptn           S              7A
     D I               S              3P 0
     D WIdx            S              3P 0
     D PAuth           S              6A
     D DDCUST          S              6A
     D PCust           S             10A
     D KFLtyp          S              2A
     D PAuthNum        S              4S 0
     D KFCust          S              6A
     D KFAuth          S             10A
     D Idx             S              3P 0
     D PErrorIndex     S              3P 0
     D RespMode        S              1A
     D WPCNT           S              3P 0                                                    CGL132
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Move Error Index (input parameter) to field Idx
      *
     C                   EVAL      Idx = PErrorIndex
      *
      ** Execute the subroutine to reset the errors
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Authority Holder
      *
     C                   EXSR      SRAuthVal
      *
      ** Validate Link Type
      *
     C                   EXSR      SRLTypVal
      *
      ** Validate Product Groups
      *
     C                   EXSR      SRPrGrpVal
      *
      ** Validate Authority Type
      *
     C                   EXSR      SRATypVal
                                                                                              CGL132
      ** Validate Controlling Interest                                                        CGL132
                                                                                              CGL132
     C                   EXSR      SRCIntVal                                                  CGL132
                                                                                              CGL132
      ** Validate Controlling Percentage                                                      CGL132
                                                                                              CGL132
     C                   EXSR      SRCPerVal                                                  CGL132
      *
      ** Execute the subroutine to update the errors
      *
     C                   EXSR      SRUpdatErrs
      *
      ** Write values to Valid fields, if no Error
      *
     C                   IF        Idx = *ZEROS
     C                   EXSR      SRSetupValid
     C                   ENDIF
      *
      ** Return from Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAuthVal - Validate Authority Holder                        *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRAuthVal     BEGSR
      *
      ** Authority Holder Number is mandatory
      *
     C                   IF        DDAUTH = *BLANKS
      *
     C**********         EVAL      AuthOk = 'N'                                               CSD091
     C**********         EVAL      Idx = Idx + 1                                              CSD091
     C**********         EVAL      FldnamXar(Idx) =                                           CSD091
     C**********                   'DDAUT' + %TRIM (%CHAR(PAuthNum))                          CSD091
     C**********         EVAL      MsgIdXAr(Idx) = 'USR5991'                                  CSD091
                                                                                              CSD091
     C**********         EVAL      AuthOk = 'W'                                      CSD091 AR855391
     C**********         EVAL      WIdx = WIdx + 1                                   CSD091 AR855391
     C**********         EVAL      WFldNmXAr(WIdx) =                                 CSD091 AR855391
     C**********                   'DDAUT' + %TRIM (%CHAR(PAuthNum))                 CSD091 AR855391
     C**********         EVAL      WMsgIDXAr(WIdx) =  'USR5991'                      CSD091 AR855391
                                                                                            AR855391
     C                   EVAL      AuthOk = 'N'                                             AR855391
     C                   EVAL      Idx = Idx + 1                                            AR855391
     C                   EVAL      FldnamXar(Idx) =                                         AR855391
     C                             'DDAUT' + %TRIM (%CHAR(PAuthNum))                        AR855391
     C                   EVAL      MsgIdXAr(Idx) = 'USR5991'                                AR855391
      *
     C                   ELSE
      *
      ** Validate authority holder number entered
      *
     C                   CALL      'AOCUSTR0'
      *
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C     PCust         PARM      DDAUTH        PCust
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd <> *BLANKS
      *
      ** Check if it is a valid Non - Account Holder
      *
     C                   CALL      'AONAHOR0'
      *
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C     PCust         PARM      DDAUTH        PCust
     C                   PARM      SDNAHO        DSLDY                                      BUG25850
     C**********         PARM      SDNAHO        DSSDY                                      BUG25850
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   IF        PRtCd = '*NOSEL '
     C                   EVAL      DDAUTH = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      AuthOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldnamXar(Idx) =
     C                              'DDAUT' + %TRIM (%CHAR(PAuthNum))
     C                   EVAL      MsgIdXAr(Idx) = 'USR5992'
      *
     C                   ELSE
      *
     C                   IF        DDAUTH = '?'
     C                   EVAL      DDAUTH = PCust
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        DDAUTH = '?'
     C                   EVAL      DDAUTH = PCust
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** The customer number must not be the same as the
      ** authority holder
      *
     C                   IF        DDCUST = DDAUTH
      *
     C                   EVAL      AuthOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldnamXar(Idx) = 'DDAUT' +
     C                                 %TRIM (%CHAR(PAuthNum))
     C                   EVAL      MsgIdXAr(Idx) = 'USR5993'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLTypVal - Validate Link Type                               *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: SRResetErrs, SRUpdatErrs                              *
      *                                                               *
      *****************************************************************
     C     SRLTypVal     BEGSR
      *
      ** Validate link type - mandatory
      *
     C                   IF        DDLTYP = *BLANKS
      *
     C                   EVAL      LtypOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldnamXar(Idx) =  'DDAUT' +                              MD050526
     C                   EVAL      FldnamXar(Idx) =  'DDLTP' +                              MD050526
     C                                  %TRIM (%CHAR(PAuthNum))
     C                   EVAL      MsgIdXAr(Idx) = 'USR5994'
      *
     C                   ELSE
      *
      ** Link type must exist on link types table
      *
     C                   EVAL      KFLtyp = DDLTYP
      *
     C*****KFLtyp        CHAIN     SDAUTPL1                                                 BUG22521
     C     KFLtyp        CHAIN     SDLINKL1                                                 BUG22521
      *
     C**********         IF        NOT %FOUND(SDAUTPL1)                                     BUG22521
     C                   IF        NOT %FOUND(SDLINKL1)                                     BUG22521
      *
     C                   EVAL      LtypOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldnamXar(Idx) = 'DDLTP' +
     C                                 %TRIM(%CHAR(PAuthNum))
     C                   EVAL      MsgIdXAr(Idx) = 'USR5995'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrGrpVal - Validate Product Groups                         *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRResetErrs, SRUpdatErrs                              *
      *                                                               *
      *****************************************************************
     C     SRPrGrpVal    BEGSR
      *
      ** Validate product groups
      ** At least one must be entered
      *
     C                   IF        DDPRG1 = *BLANKS
     C                             AND DDPRG2 = *BLANKS
     C                             AND DDPRG3 = *BLANKS
     C                             AND DDPRG4 = *BLANKS
      *
     C                   EVAL      Prgp1Ok = 'N'
     C                   EVAL      Prgp2Ok = 'N'
     C                   EVAL      Prgp3Ok = 'N'
     C                   EVAL      Prgp4Ok = 'N'
      *
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR5996'
     C                   EVAL      FldnamXar(Idx) =  'DDPG' + '1' +
     C                             %TRIM (%CHAR(PAuthNum))
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR5996'                                MD050526
     C                   EVAL      FldnamXar(Idx) =  'DDPG' + '2' +
     C                             %TRIM (%CHAR(PAuthNum))
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR5996'                                MD050526
     C                   EVAL      FldnamXar(Idx) =  'DDPG' + '3' +
     C                             %TRIM (%CHAR(PAuthNum))
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'USR5996'                                MD050526
     C                   EVAL      FldnamXar(Idx) =  'DDPG' + '4' +
     C                             %TRIM (%CHAR(PAuthNum))
      *
     C                   ENDIF
      *
      ** Product Group 1 entered must be valid
      *
     C                   IF        DDPRG1 <> *BLANKS
     C                             AND DDPRG1 <> 'AL'
     C                             AND DDPRG1 <> 'LE'
     C                             AND DDPRG1 <> 'RE'
     C                             AND DDPRG1 <> 'MM'
     C                             AND DDPRG1 <> 'OT'
      *
     C                   EVAL      Prgp1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldnamXar(Idx) =  'DDPG' + '1' +
     C                               %TRIM (%CHAR(PAuthNum))
     C                   EVAL      MsgIdXAr(Idx) = 'USR5997'
      *
     C                   ENDIF
      *
      ** Product Group 2 entered must be valid
      *
     C                   IF        DDPRG2 <> *BLANKS
     C                             AND DDPRG2 <> 'AL'
     C                             AND DDPRG2 <> 'LE'
     C                             AND DDPRG2 <> 'RE'
     C                             AND DDPRG2 <> 'MM'
     C                             AND DDPRG2 <> 'OT'
      *
     C                   EVAL      Prgp2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldnamXar(Idx) =  'DDPG' + '2' +
     C                               %TRIM (%CHAR(PAuthNum))
     C                   EVAL      MsgIdXAr(Idx) = 'USR5997'
      *
     C                   ENDIF
      *
      ** Product Group 3 entered must be valid
      *
     C                   IF        DDPRG3 <> *BLANKS
     C                             AND DDPRG3 <> 'AL'
     C                             AND DDPRG3 <> 'LE'
     C                             AND DDPRG3 <> 'RE'
     C                             AND DDPRG3 <> 'MM'
     C                             AND DDPRG3 <> 'OT'
      *
     C                   EVAL      Prgp3Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldnamXar(Idx) =  'DDPG' + '3' +
     C                               %TRIM (%CHAR(PAuthNum))
     C                   EVAL      MsgIdXAr(Idx) = 'USR5997'
      *
     C                   ENDIF
      *
      ** Product Group 4 entered must be valid
      *
     C                   IF        DDPRG4 <> *BLANKS
     C                             AND DDPRG4 <> 'AL'
     C                             AND DDPRG4 <> 'LE'
     C                             AND DDPRG4 <> 'RE'
     C                             AND DDPRG4 <> 'MM'
     C                             AND DDPRG4 <> 'OT'
      *
     C                   EVAL      Prgp4Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldnamXar(Idx) =  'DDPG' + '4' +
     C                               %TRIM (%CHAR(PAuthNum))
     C                   EVAL      MsgIdXAr(Idx) = 'USR5997'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRATypVal - Validate Authority Type                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRResetErrs, SRUpdatErrs                              *
      *                                                               *
      *****************************************************************
     C     SRATypVal     BEGSR
      *
      ** Authority type must exist on Authority types table
      *
     C                   IF        DDTYPA <> *BLANKS                                        BUG25850
     C                   EVAL      KFLtyp = DDTYPA
      *
     C     KFLtyp        CHAIN     SDAUTPL1
      *
     C                   IF        NOT %FOUND(SDAUTPL1)
      *
     C                   EVAL      AtypOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldnamXar(Idx) = 'DDTPA' +
     C                               %TRIM (%CHAR(PAuthNum))
     C**********         EVAL      MsgIdXAr(Idx) = 'USR5999'                                BUG25850
     C                   EVAL      MsgIdXAr(Idx) = 'USR8438'                                BUG25850
      *
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG25850
      *                                                                                     BUG25850
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      *  SRCIntVal - Validate Controlling Interest                    *                       CGL132
      *                                                               *                       CGL132
      *  Called by: Main Processing                                   *                       CGL132
      *                                                               *                       CGL132
      *  Calls: SRResetErrs, SRUpdatErrs                              *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
     C     SRCIntVal     BEGSR                                                                CGL132
      *                                                                                       CGL132
      ** Controlling Interest must be Y or N, defaults to N                                   CGL132
      *                                                                                       CGL132
     C                   IF        DDCINT = *BLANKS                                           CGL132
     C                   EVAL      DDCINT = 'N'                                               CGL132
     C                   ENDIF                                                                CGL132
      *                                                                                       CGL132
     C                   IF        DDCINT <> 'Y' AND                                          CGL132
     C                             DDCINT <> 'N'                                              CGL132
      *                                                                                       CGL132
     C                   EVAL      CIntOk = 'N'                                               CGL132
     C                   EVAL      Idx = Idx + 1                                              CGL132
     C                   EVAL      FldnamXar(Idx) = 'DDCINT'+                                 CGL132
     C                               %TRIM (%CHAR(PAuthNum))                                  CGL132
     C                   EVAL      MsgIdXAr(Idx) = 'USS0321'                                  CGL132
      *                                                                                       CGL132
     C                   ENDIF                                                                CGL132
      *                                                                                       CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      *  SRCPerVal - Validate Controlling Percentage                  *                       CGL132
      *                                                               *                       CGL132
      *  Called by: Main Processing                                   *                       CGL132
      *                                                               *                       CGL132
      *  Calls: SRResetErrs, SRUpdatErrs                              *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
     C     SRCPerVal     BEGSR                                                                CGL132
      *                                                                                       CGL132
      ** Controlling Interest must be between 0 to 100 if input                               CGL132
      *                                                                                       CGL132
     C                   MOVE      DDPCNT        WPCNT                                        CGL132
     C                   IF        WPCNT <   0 OR                                             CGL132
     C                             WPCNT > 100                                                CGL132
      *                                                                                       CGL132
     C                   EVAL      CPerOk = 'N'                                               CGL132
     C                   EVAL      Idx = Idx + 1                                              CGL132
     C                   EVAL      FldnamXar(Idx) = 'DDPCNT'+                                 CGL132
     C                               %TRIM (%CHAR(PAuthNum))                                  CGL132
     C                   EVAL      MsgIdXAr(Idx) = 'USS0322'                                  CGL132
      *                                                                                       CGL132
     C                   ENDIF                                                                CGL132
      *                                                                                       CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************
      *                                                               *
      *  SRSetupValid - Set up Valid field values                     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRResetErrs, SRUpdatErrs                              *
      *                                                               *
      *****************************************************************
     C     SRSetupValid  BEGSR
      *
     C                   EVAL      ACCUST = DDCUST
     C                   EVAL      ACAUTH = DDAUTH
     C                   EVAL      ACLTYP = DDLTYP
     C                   EVAL      ACTYPA = DDTYPA
     C                   EVAL      ACPRG1 = DDPRG1
     C                   EVAL      ACPRG2 = DDPRG2
     C                   EVAL      ACPRG3 = DDPRG3
     C                   EVAL      ACPRG4 = DDPRG4
     C                   EVAL      ACCINT = DDCINT                                            CGL132
     C                   EVAL      ACPCNT = DDPCNT                                            CGL132
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Reset error information that is received back  *
      *                from each validation module                    *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRResetErrs   BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdatErrs - Update error information with that received    *
      *                back from each validation module               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANKS       LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
      *
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
      *
     C                   ENDIF
      *
      ** Set Error Index
      *
     C                   Z-ADD     1             I
     C     *BLANKS       LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANKS       LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
      *
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
      *
     C                   ENDIF
      *
      ** Set Warning Index
      *
     C                   Z-ADD     1             I
     C     *BLANKS       LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RespMode
     C                   PARM                    PAuthNum
     C                   PARM                    DDCUST
     C                   PARM                    CustAuth
     C                   PARM                    OKCustAuth
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    PErrorIndex
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    SDVCUAH
      *
     C     KLPrvK        KLIST
     C                   KFLD                    KFCust
     C                   KFLD                    KFAuth
     C                   KFLD                    KFLTyp
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
