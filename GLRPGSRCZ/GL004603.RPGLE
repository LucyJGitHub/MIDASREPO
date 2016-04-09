     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Trailer Update')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004603 - GL Account Transfer Trailer Update                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG27742 *CREATE   Date 01Jun10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27742 - Locking issues on files T_SEQUENCE, GLATTRPD and  *
      *             T_MLRSVTRN during Chicago Release performance     *
      *             testing.                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    nn         Function of Indicator                           *
      *    91 to 99 - Indicators used by GLZADD and GLZSUM            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRTrail - GLATTRPD trailer update                            *
      *  GLZADD - Add and Amount to th Total                          *
      *  GLZSUM - Carry Out Addition                                  *
      *                                                               *
      *****************************************************************
 
      ** Midas GL Account Transfer Manual Input File - Trailer
     FGLATTRPD  UF A E             DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D ReturnMsg       S              7A
     D Action          S              1A
     D BDRAmt          S             13P 0
     D ADRAmt          S             13P 0
     D WRetCode        S              7A
     D WOption         S              7A
 
      ** Fields used in GLZADD/GLZSUM
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWk2           S              4  0
     D ZZWk3           S             15  0
     D ZZNEGD          S              5
 
     D WkVlInt         S             15  0
     D WkVlDec         S              3  0
      ** +--- Start of main processing -----------------------------------+
 
     C                   Eval      ReturnMsg  = *BLANKS
     C                   EXSR      SRTrail
     C
     C                   SetOn                                        LR
     C                   Return
      *****************************************************************
      * SRTrail - GLATTRPD trailer update                             *
      *****************************************************************
     C     SRTrail       BEGSR
 
     C                   READ      GLATTRPD
 
     C                   If        NOT(%EOF(GLATTRPD))
 
     C                   Select
     C                   When      Action = 'I'
     C                   Eval      T1NORC = T1NORC + 1
     C                   Eval      T1NOIN = T1NOIN + 1
     C                   When      Action = 'A'
     C                   Eval      T1NOAM = T1NOAM + 1
     C                   When      Action = 'D'
     C                   Eval      T1NODL = T1NODL + 1
     C                   End
 
      ** Calculate trailer totals if Action is Insert or Amend.
      ** For Delete action, there should be no change in trailer totals
      ** as RECI is only set to R and the record is only not physically
      ** removed from GLATMIPD
 
     C                   If        Action = 'A' or Action = 'I'
     C                   EVAL      ZZAMT = ADRAmt / 1000
     C                   If        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   EndIf
 
     C                   Z-ADD     T1HRWN        ZZTOTI
     C                   Z-ADD     T1HRDC        ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        T1HRWN
     C                   Z-ADD     ZZTOTD        T1HRDC
     C                   EndIf
 
      ** Subtract the old Debit Amount from the trailer totals for Amend action
 
     C                   If        Action = 'A'
     C                   EVAL      ZZAMT = BDRAmt / 1000
     C                   Z-SUB     ZZAMT         ZZAMT
 
     C                   Z-ADD     T1HRWN        ZZTOTI
     C                   Z-ADD     T1HRDC        ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        T1HRWN
     C                   Z-ADD     ZZTOTD        T1HRDC
     C                   Endif
 
     C                   Eval      T1LCDT = BJRDNB
     C                   TIME                    T1LCTM
     C                   Eval      T1CHTP = 'A'
 
     C                   Update    GLATTRD0
 
     C                   Else
      *
      ** Create trailer record if not found in GLATTRPD
      *
     C                   Clear                   GLATTRD0
     C                   Eval      T1RECI = 'T'
     C                   Eval      T1NORC = 1
 
     C                   Select
     C                   When      Action = 'I'
     C                   Eval      T1NOIN = 1
     C                   When      Action = 'A'
     C                   Eval      T1NOAM = 1
     C                   When      Action = 'D'
     C                   Eval      T1NODL = 1
     C                   End
 
     C                   EVAL      ZZAMT = ADRAmt / 1000
     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        T1HRWN
     C                   Z-ADD     ZZTOTD        T1HRDC
 
     C                   Eval      T1LCDT = BJRDNB
     C                   TIME                    T1LCTM
     C                   Eval      T1CHTP = 'A'
 
     C                   Write     GLATTRD0
 
     C                   EndIf
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Initialisation                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **--------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------
     C     *Entry        PList
     C                   Parm                    ReturnMsg
     C                   Parm                    Action
     C                   Parm                    ADRAmt
     C                   Parm                    BDRAmt
 
      *
      ** Access Bank details via access program
      ** (database error handling done in access program)
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRetCode
     C                   PARM      '*FIRST '     WOption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     WRetCode      IFNE      *BLANK
     C                   MOVEL     WOption       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLZADD - Subroutine to add an amount to the total             *
      *                                                               *
      *****************************************************************
      *
     C     GLZADD        BEGSR
 
     C                   Z-ADD     ZZAMT         ZZAMT                    91
 
     C                   IF        *IN91 = *ON
     C                   GOTO      ZZAEND
     C                   ENDIF
 
      ** Split ZZAMT into integer and decimal fields
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now
 
     C                   EXSR      GLZSUM
 
     C     ZZAEND        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GLZSUM - Subroutine to carry out the additon for subroutine   *
      *                                                               *
      *****************************************************************
 
     C     GLZSUM        BEGSR
 
     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF
 
      ** Determine sign of ZZAMTI & D, 92 if neg.
 
     C     ZZAMTI        COMP      0                                    9293
 
     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      0                                    9293
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** Determine sign of ZZTOTI & D, 91 if neg.
 
     C     ZZTOTI        COMP      0                                    9193
 
     C                   IF        *IN93 = *ON
     C     ZZTOTD        COMP      0                                    9193
     C                   ENDIF
 
      ** If ZZTOTAL is zero, return ZZAMOUNT.
 
     C                   IF        *IN93 = *ON
     C                   Z-ADD     ZZAMTI        ZZTOTI
     C                   Z-ADD     ZZAMTD        ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** If signs differ bypass overflow checks.
 
     C                   IF        *IN91 = *ON AND
     C                             *IN92 = *OFF OR
     C                             *IN91 = *OFF AND
     C                             *IN92 = *ON
     C                   GOTO      ZZOFPS
     C                   ENDIF
 
     C     ZZAMTD        ADD       ZZTOTD        ZZWk2
     C     ZZWk2         COMP      999                                93
 
     C                   IF        *IN93 = *OFF
     C     ZZWk2         COMP      -999                                 93
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *OFF
     C     ZZAMTI        ADD       1             ZZWk3
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *ON
     C     ZZAMTI        SUB       1             ZZWk3
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C     ZZTOTI        ADD       ZZWk3         ZZWk3
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF
     C     ZZTOTI        ADD       ZZAMTI        ZZWk3
     C                   ENDIF
 
      ** If the modulus of ZZWk3 is lt mod. ZZTOTI then O/F has occurred
 
     C                   IF        *IN92 = *OFF
     C     ZZWk3         COMP      ZZTOTI                               99
     C                   ENDIF
 
     C                   IF        *IN92 = *ON
     C     ZZWk3         COMP      ZZTOTI                             99
     C                   ENDIF
 
     C                   IF        *IN99 = *OFF
     C                   Z-ADD     ZZWk2         ZZTOTD
     C                   Z-ADD     ZZWk3         ZZTOTI
     C                   ENDIF
 
      ** If O/F zeroise ZZAMT, ind '99' set and ZZTOT fields left intact
 
     C                   IF        *IN99 = *ON
     C                   Z-ADD     0             ZZAMT
     C                   ENDIF
 
     C                   GOTO      ZZSEND
 
      ** The 'SIGNS' are different
 
     C     ZZOFPS        TAG
 
      ** If ZZAMT was negative, make it pos. to comp with ZZTOT
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.
 
     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Both ZZAMT and ZZTOT are noe positive
 
     C     ZZTOTI        COMP      ZZAMTI                             93  95
 
     C                   IF        *IN95 = *ON
     C     ZZTOTD        COMP      ZZAMTD                             93  95
     C                   ENDIF
 
      ** If ZZTOT eq. ZZAMT return zero.
 
     C                   IF        *IN95 = *ON
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF
 
      ** If ZZTOT gt. ZZAMT.
 
     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      ZZTOTD                             94
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZTOTI        SUB       1             ZZTOTI
     C     ZZTOTD        ADD       1000          ZZWk2
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZWk2         SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *OFF
     C     ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
 
      ** If ZZAMT gt. ZZTOT.
 
     C                   IF        *IN93 = *OFF
     C     ZZTOTD        COMP      ZZAMTD                             94
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZAMTI        SUB       1             ZZWk3
     C     ZZAMTD        ADD       1000          ZZWk2
     C     ZZWk3         SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZWk2         SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
 
     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Reverse sign of ZZTOT if larger I/P fields were negative
 
     C                   EVAL      *IN94 = *OFF
 
     C                   IF        *IN93 = *ON AND
     C                             *IN91 = *ON OR
     C                             *IN93 = *OFF AND
     C                             *IN92 = *ON
     C                   EVAL      *IN94 = *ON
     C                   ENDIF
 
     C                   IF        *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Restore sign of ZZAMTI & ZZAMTD If It was reversed.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
     C     ZZSEND        TAG
 
      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
 
     C                   EVAL      *IN96 = *OFF
 
     C     ZZTOTD        COMP      0                                      91
 
     C                   IF        *IN91 = *ON
     C     ZZTOTI        COMP      0                                    96
     C                   ENDIF
 
     C                   IF        *IN96 = *ON
     C                   MOVE      '.000-'       ZZNEGD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *         Called automatically if a program error occurs,       *
      *         or directly by the program code using EXSR.           *
      *         This subroutine DUMPs the program just once.          *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      ReturnMsg = '*ERROR '
     C                   EVAL      RunBefore = ' '
     C                   RETURN
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
