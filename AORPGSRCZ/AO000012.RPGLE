     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AO Customer Exchange adoption program')          *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  AO000012 - Customer Exchange adoption program               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. AR1061148          Date 08Feb13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27210           Date 15Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247922             Date 05Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12821           Date 11Dec06               *
      *                 239164             Date 30Mar06               *
      *                 238797             Date 08Mar06               *
      *                 238223             Date 27Jan06               *
      *                 BUG10779           Date 10Mar06               *
      *                 BUG8638 *CREATE    Date 22Nov05               *
      * Midas Plus 1.2 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1061148 - Account Transfer transaction not reflected on    *
      *              Customer's Account                               *
      *  BUG27210 - Transaction Reference is truncated                *
      *  247922 - Applied core fixes 239164 and BUG12821.             *
      *  BUG12821-Decimal data error occured due to wrong data        *
      *           mapping.                                            *
      *  239164 - Pass all data from JAVA direct to AOSPOSU0.  This   *
      *           is to prevent errors on negative sign.              *
      *           Additional enhancement is to write to MOPERQ.       *
      *  238797 - MidasPlus trace program for CUSX.                   *
      *           Applied fix 238223 and BUG8638.                     *
      *  238223 - MidasPlus trace program for CUSX.                   *
      *  BUG10779 - Customer exchange adoption program                *
      *  BUG8638 - Customer exchange adoption program                 *
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
 
      ** Entry parameters
     D Action          S              8
     D Input           S            267
     D ReturnMsg       S            256
     D ErrorCode       S              7
     D TransType       S              4                                                       239164
 
     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')
 
     D*Parm*****       DS          1000                                                    AR1061148
     D Parm            DS          3193                                                    AR1061148
     D OffSetB               361    364B 0
     D LibCountB             365    368B 0
 
     D Len             S              4B 0 INZ(1000)
 
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
      ** Data area containing system prefix
     D SDSTAT        E DS                  DTAARA(SDSTAT)
 
     D*InParm**********DS***********267                                                       239164
 
     D*CharFlds1In*************1*****88                                                       239164
     D*AmtIn******************89****103  0                                                    239164
     D*CharFlds2In***********104****112                                                       239164
     D*VDatIn****************113****117  0                                                    239164
     D*PDatIn****************118****122  0                                                    239164
     D*CharFlds3In***********123****267                                                       239164
 
     D*OutParm*********DS***********256                                                       239164
 
     D*CharFlds1Out************1*****88                                                       239164
     D*AmtOut*****************89*****96P 0                                                    239164
     D*CharFlds2Out***********97****105                                                       239164
     D*VDatOut***************106****108P 0                                                    239164
     D*PDatOut***************109****111P 0                                                    239164
     D*CharFlds3Out**********112****256                                                       239164
      *                                                                                     BUG12821
     D I@JavaInp       DS           256                                                     BUG12821
     D  I@CustDtl1             1     88                                                     BUG12821
     D  I@MoveAmnt            89    103                                                     BUG12821
     D  I@ProcInd1           104    112                                                     BUG12821
     D  I@ValuDate           113    117                                                     BUG12821
     D  I@PostDate           118    122                                                     BUG12821
     D  I@ProcInd2           123    128                                                     BUG12821
     D  I@CustDtl2           129    141                                                     BUG12821
     D  I@DFiller1           142    256                                                     BUG12821
                                                                                            BUG12821
     D I@RpgOut        DS           256                                                     BUG12821
     D  O@CustDtl1             1     88                                                     BUG12821
     D  O@MoveAmnt            89     96P 0                                                  BUG12821
     D  O@ProcInd1            97    105                                                     BUG12821
     D  O@ValuDate           106    108P 0                                                  BUG12821
     D  O@PostDate           109    111P 0                                                  BUG12821
     D  O@ProcInd2           112    117                                                     BUG12821
     D**O@CustDtl2           118    140                                            BUG12821 BUG27210
     D**O@DFiller1           141    256                                            BUG12821 BUG27210
     D  O@CustDtl2           118    130                                                     BUG27210
     D  O@DFiller1           131    256                                                     BUG27210
 
      ** +--- Start of main processing -----------------------------------+
 
     C                   Eval      ErrorCode  = *BLANKS
     C                   Eval      ReturnMsg  = *BLANKS
 
     C                   In        SDSTAT
     C                   Eval      System = Libr
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
     C                   EVAL      ReturnMsg = 'Midas system job +
     C                             description not found.'
     C                   Return
     C                   Endif
     C                   If        QUSEI = 'CPF9802' OR
     C                             QUSEI = 'CPF9820'
     C                   EVAL      ReturnMsg = 'Not authorised to Midas +
     C                             system job description.'
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
 
     C                   MoveL     InpDS         Inp256          256                          239164
     C                   MOVEL     InpDS         I@Javainp                                  BUG12821
     C                   EVAL      O@CustDtl1 = I@CustDtl1                                  BUG12821
     C                   MOVE      I@MoveAmnt    O@MoveAmnt                                 BUG12821
     C                   IF        %SUBST(I@MoveAmnt:1:1) = '-'                             BUG12821
     C                   EVAL      O@MoveAmnt = O@MoveAmnt * -1                             BUG12821
     C                   ENDIF                                                              BUG12821
     C                   EVAL      O@ProcInd1 = I@ProcInd1                                  BUG12821
     C                   MOVE      I@ValuDate    O@ValuDate                                 BUG12821
     C                   MOVE      I@PostDate    O@PostDate                                 BUG12821
     C                   EVAL      O@ProcInd2 = I@ProcInd2                                  BUG12821
     C                   EVAL      O@CustDtl2 = I@CustDtl2                                  BUG12821
     C                   EVAL      O@DFiller1 = I@DFiller1                                  BUG12821
     C                   MOVE      I@RpgOut      Inp256                                     BUG12821
                                                                                              239164
     C                   Call      'AOC000014'                                                239164
     C                   Parm                    TransType                                    239164
     C                   Parm                    ReturnMsg                                    239164
     C                   Parm                    P#Action                                     239164
     C                   Parm                    Inp256                                       239164
                                                                                              239164
     C                   If        ReturnMsg <> *BLANKS                                       239164
     C                   DUMP                                                                 239164
     C                   EndIf                                                                239164
                                                                                              239164
     C**********         Eval      CharFlds1Out = CharFlds1In                                 239164
     C**********         Z-Add     AmtIn         AmtOut                                       239164
     C**********         Eval      CharFlds2Out = CharFlds2In                                 239164
     C**********         Z-Add     VDatIn        VDatOut                                      239164
     C**********         Z-Add     PDatIn        PDatOut                                      239164
     C**********         Eval      CharFlds3Out = CharFlds3In                                 239164
      **********                                                                       238223 239164
      ** Call Trace program to dump parameter from JAVA to PF                          238223 239164
      **********                                                                       238223 239164
     C**********         MoveL     ReturnMsg     PRTCD                                 238223 239164
      **********                                                                       238223 239164
     C**********         Call      'AO000011'                                          238223 239164
     C**********         Parm      *BLANKS       ARTCD             7                   238223 239164
     C**********         Parm      *BLANKS       PBUFC             1                   238223 239164
     C**********         Parm                    PRTCD             7                   238223 239164
     C**********         Parm      Action        PACTN             8                   238223 239164
     C**********         Parm      OutParm       PDATA           256                   238223 239164
      **********                                                                       238223 239164
     C*****ARTCD         IFNE      *BLANKS                                             238223 239164
     C**********         EVAL      ReturnMsg = 'AO12001: Program AO000011 +            238223 239164
     C**********                   ended in error(1st run)'                            238223 239164
     C**********         Endif                                                         238223 239164
      **********                                                                       238223 239164
      ** Call Online Update program                                                    238223 239164
      **********                                                                              239164
     c**********         Call      'AOSPOSU0'                                                 239164
     C**********         Parm                    ErrorCode                                    239164
     C**********         Parm                    Action                                       239164
     C*****OutParm       Parm      OutParm       OutDS           256                          239164
      **********                                                                              239164
     C**********         Eval      CharFlds1In = CharFlds1Out                                 239164
     C**********         Z-Add     AmtOut        AmtIn                                        239164
     C**********         Eval      CharFlds2In = CharFlds2Out                                 239164
     C**********         Z-Add     VDatOut       VDatIn                                       239164
     C**********         Z-Add     PDatOut       PDatIn                                       239164
     C**********         Eval      CharFlds3In = CharFlds3Out                                 239164
      **********                                                                              239164
      **********                                                                              239164
     C**********         If        ErrorCode  = '*ERROR*'                                     239164
     C**********         ExSR      *PSSR                                                      239164
     C**********         EndIf                                                                239164
      **********                                                                       238223 239164
     C**********         If        OutParm <> OutDS                                    238223 239164
     C**********         MoveL     ReturnMsg     PRTCD                                 238223 239164
      **********                                                                       238223 239164
     C**********         Call      'AO000011'                                          238223 239164
     C**********         Parm      *BLANKS       ARTCD             7                   238223 239164
     C**********         Parm      'Y'           PBUFC             1                   238223 239164
     C**********         Parm                    PRTCD             7                   238223 239164
     C**********         Parm      Action        PACTN             8                   238223 239164
     C**********         Parm      OutParm       PDATA           256                   238223 239164
      **********                                                                       238223 239164
     C*****ARTCD         IFNE      *BLANKS                                             238223 239164
     C**********         EVAL      ReturnMsg = 'AO12002: Program AO000011 +            238223 239164
     C**********                   ended in error(2nd run)'                            238223 239164
     C**********         Endif                                                         238223 239164
     C**********         EndIf                                                         238223 239164
 
     C                   SetOn                                        LR
     C                   Return
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
     C     *Entry        PList
     C                   Parm                    ReturnMsg
     C**********         Parm                    Action            8                          239164
     C*****InParm        Parm      InParm        InpDS           267                          239164
     C                   Parm                    P#Action          8                          239164
     C                   Parm                    InpDS           267                          239164
 
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
     C**********         EVAL      ReturnMsg = 'System error has +                           239164
     C**********                   occurred in Midas. Please inform +                        239164
     C**********                   a Midas System operator.'                                 239164
     C                   EVAL      ReturnMsg = 'AO000012: System error has +                 239164
     C                             occurred in Midas. Please inform +                        239164
     C                             a Midas System operator.'                                 239164
     C                   EVAL      RunBefore = ' '                                           239164
     C                   RETURN
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
