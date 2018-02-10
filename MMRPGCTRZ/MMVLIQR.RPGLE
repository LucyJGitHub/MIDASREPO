     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Liquidity/Premium Rate and Sign')    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVLIQR - Validate Liquidity/Premium Rate and Sign           *
      *                                                               *
      *  Function:  This program validates the liquidity/premium      *
      *             rate and sign of all MM Loans/Deposits and        *
      *             NAs Purchased transactions.                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 245692             Date 12Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249031             Date 20Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG5508            Date 08Mar05               *
      *                 224059             Date 30Dec02               *
      *                 CAS005  *CREATE    Date 16Dec02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249031 - Extend fix 224059 to prevent divide by zero error   *
      *  BUG5508- Should only be a warning if N-T-R is less then zero.*
      *  224059 - Ensure that N-T-R Interest is Initialized           *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Liquidity/Premium Rate
 
     D PDDLQPR         S             12A
 
      ** Liquidity Sign
 
     D PDDLQPS         S              1A
 
      ** Interest Rate
 
     D PIFINTR         S             11P 7
 
      ** Total Interest
 
     D PMTTI           S             15  0
 
      ** Total Interest
 
     D PNTOTI          S             15  0
 
      ** Net-Treasury Rate
 
     D WNTR            S             11P 7
 
     D ZFLD11          S             11P 7
 
      ** Valid File Format of Liquidity/Premium Rate
 
     D PIFLQPR         S             11P 7
 
      ** Valid File Format of Liquidity/Premium Sign
 
     D PIFLQPS         S              1A
 
      ** Returns 'Y' or 'N' depending on whether validation has been successful
 
     D ZALIGNok        S              1A
     D POKLQPR         S              1A
     D POKLQPS         S              1A
 
      ** Return Code
 
     D PRetCode        S              7A
 
      **  Error message code 1 received as a parameter
 
     D PMsg1           S                   LIKE(#MsgID)
     D PMsg2           S                   LIKE(#MsgID)
 
      **  A 16 character alphanumeric field to contain numeric input
      **  The field may contain leading and trailing blanks and a
      **  decimal point,and may have up to 15 digits.
 
     D ZFIELD          S             16A
 
      **  contains the required number of digits before the decimal
      **  point as a constant.
 
     D ZADEC           S              1P 0
 
      ** contains required number of digits before the decimal point as
      ** a constant in program.
 
     D ZADIG           S              2P 0
 
     D ZAOPT           S              1A
     D WNTOTI          S             15  0
 
      ** Decimal separator                                                                    245692
     D BNDCSP          S              1A                                                      245692
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset the error flag to prevent problems on subsequent calls
 
     C                   RESET                   PMsg1
     C                   RESET                   PMsg2
 
      ** Validate Liquidity/Premium Rate using ZALIGN.
 
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C     PDDLQPR       IFNE      *BLANKS
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         Z-ADD     7             ZADEC                                        245692
     C**********         Z-ADD     4             ZADIG                                        245692
     C**********         MOVEL     PDDLQPR       ZFIELD                                       245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      PDDLQPR       @@ALPH                                       245692
     C                   Z-ADD     4             @@IINT                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C                   MOVE      'N'           ZAOPT
 
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM                    ZALIGNok                                     245692
     C**********         PARM                    ZFIELD                                       245692
     C**********         PARM                    ZADEC                                        245692
     C**********         PARM                    ZADIG                                        245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
 
      ** Send error message if liquidity/premium rate is not a valid format
 
     C**********         IF        ZALIGNok = 'Y'                                             245692
     C     @@ERCD        IFEQ      0                                                          245692
     C                   Z-ADD     0             ZFLD11
     C**********         MOVE      ZFIELD        ZFLD11                                       245692
     C                   MOVE      @@AMT         ZFLD11                                       245692
     C                   ELSE
 
     C                   MOVE      'MMA1305'     PMsg1
     C                   EVAL      POKLQPR = 'N'
     C                   EVAL      PRetCode = '*ERROR'
     C                   ENDIF
 
      ** Liquidity premium is blanks
 
     C                   ELSE
     C                   Z-ADD     0             ZFLD11
     C                   ENDIF
 
      ** Check Liquidity sign
 
     C                   IF        PDDLQPS = *BLANKS
     C                   EVAL      PDDLQPS = '+'
     C                   ENDIF
 
     C                   IF        PDDLQPS <> '+' AND PDDLQPS <> '-'
     C                   MOVEL     'MMA1306'     PMsg2
     C                   EVAL      POKLQPS = 'N'
     C                   EVAL      PRetCode = '*ERROR'
     C                   ENDIF
 
     C                   IF        POKLQPR = 'Y' AND POKLQPS = 'Y'
     C                   EXSR      SRVALID
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALID - Move Fields to File Format Fields                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVALID       BEGSR
 
      ** If no error occurs
 
     C                   IF        PDDLQPS = '+'
     C                   EVAL      WNTR = PIFINTR + ZFLD11
     C                   ELSE
     C                   EVAL      WNTR = PIFINTR - ZFLD11
     C                   ENDIF
 
     C     WNTR          IFLT      0
     C                   MOVEL     'MMA1307'     PMsg1
     C****************** EVAL      POKLQPR = 'N'                                             BUG5508
     C****************** EVAL      PRetCode = '*ERROR'                                       BUG5508
     C                   EVAL      POKLQPR = 'W'                                             BUG5508
     C                   EVAL      PRetCode = 'Warning'                                      BUG5508
     C                   ELSE
     C                   EVAL      PIFLQPR = ZFLD11
     C                   EVAL      PIFLQPS = PDDLQPS
                                                                                              224059
     C                   EVAL      PNTOTI = 0                                                 224059
 
     C*****PMTTI         IFGT      0                                                          224059
     C     PMTTI         IFNE      0                                                          224059
     C     PIFINTR       ANDNE     0                                                          249031
     C                   EVAL      WNTOTI = 0
     C**********         EVAL      PNTOTI = 0                                                 224059
     C     PMTTI         DIV       PIFINTR       WNTOTI
     C     WNTOTI        MULT      WNTR          PNTOTI
     C                   ENDIF
 
     C                   ENDIF
 
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
 
      ** Input Parameters
 
     C                   PARM                    PRetCode
     C                   PARM                    PIFINTR
     C                   PARM                    PDDLQPR
     C                   PARM                    PDDLQPS
     C                   PARM                    PMTTI
 
      ** Output Parameters
 
     C                   PARM                    PMsg1
     C                   PARM                    PMsg2
     C                   PARM                    POKLQPR
     C                   PARM                    POKLQPS
     C                   PARM                    PIFLQPR
     C                   PARM                    PIFLQPS
     C                   PARM                    PNTOTI
     C                   PARM                    BNDCSP                                       245692
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
