     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Convert screen price to file format')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFPRVL - Convert screen price to file format                 *
      *                                                               *
      *  Function:  This module is a conversion of the external       *
      *             subroutine FFPRVL, comprising the 3 /COPY members *
      *             FFPRVLZ2, FFPRVLZ3 and FFPRVLZ4.                  *
      *             In addition it uses a converted version of tbe    *
      *             /COPY member FFSRDSZ1, which is a common data     *
      *             structure definition for the FF subroutines.      *
      *             The three members which include I- or E-specs     *
      *             (FFSRDSZ1, FFPRVLZ2 and FFPRVLZ3) were merged     *
      *             into one before conversion to ILE.  This allows   *
      *             the converter to correctly turn their             *
      *             interrelated contents into D-specs correctly.     *
      *             Note that if any change needs to be done it       *
      *             should be applied to the /COPY members and they   *
      *             should be reconverted to replace this module.     *
      *             The function is to convert the file version of a  *
      *             price to a 16A screen format.  For the full       *
      *             details see the member FFPRVLZTXT in ZSRSRC.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CFF006             Date 28Nov00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFF006 - Fractional Ticks Enhancement.                       *
      *  CAP004 - Conversion of Midas inputs to APIs                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     ** *--------------------*
     ** | Note on conversion |
     ** *--------------------*----------------------------------------------
     ** Note that the three members FFPRVLZ2, FFPRVLZ3 and FFSRDSZ1 were
     ** merged before being converted to ILE RPG, so that both the E- and
     ** I-specs could be properly converted to D-specs.
     ** --------------------------------------------------------------------
     ** +--- Start converted, merged FFPRVLZ2, FFPRVLZ3 and FFSRDSZ1 ------+
     D FFDC            S              1    DIM(3)                               FFPRVL SR. ARRAY
     D FFMF            S              1  0 DIM(8)                               FFPRCS SR. ARRAY CFF
 
     D                 DS
      **   FFSPRC ( Screen Format of Price )
     D  FFSP                   1     16                                         CFF004
     D                                     DIM(16)                              FFPRCS/FFPRVL SR.CFF
     D  FFSPRC                 1     16                                         CFF004
 
     D                 DS
     D  FFFP                   1     15  0                                      CFF004
     D                                     DIM(15)                              FFPRCS SR. ARRAY CFF
     D  FFPRIC                 1     15  8                                      CFF004
     D  FFINTG                 1      7  0                                      CFF004
     D  FFIN                   1      7                                         CFF004
     D                                     DIM(7)                               FFPRVL SR. ARRAY CFF
     D  FFDCN1                 8      8  0                                      CFF004
     D  FFDCN2                 8      9  0                                      CFF004
     D  FFDCN3                 8     10  0                                      CFF004
     D  FFDECN                 8     10  0                                      CFF004
     D  FFDECD                 8     15  0                                      CFF004
     D  FFDECA                 8     15                                         CFF004
     D  FFDCN4                 9     11  3                                                    CFF006
     D  FFDCN5                10     12  3                                                    CFF006
     D  FFDCN6                11     13  3                                                    CFF006
     ** +--- End converted, merged FFPRVLZ2, FFPRVLZ3 and FFSRDSZ1 --------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** File version of price
     D FilePrice       S             15P 8
 
      ** Screen version of price
     D ScreenPric      S                   LIKE(FFSPRC)
 
     D FFAR            S              1    DIM(15)                                            CFF006
     D FFDCDP          S             15  8                                                    CFF006
     D N               S              2  0                                                    CFF006
     D P               S              2  0                                                    CFF006
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      ** Put the input version of the screen price into the subroutine field
     C                   EVAL      FFSPRC = ScreenPric
 
     C                   EXSR      FFPRVL
 
      ** Put the subroutine version of the file price into the output
      ** Version
     C                   EVAL      FilePrice = FFPRIC
 
      ** If the error indicator was set, set the error flag to cause
      ** the return code to be set
     C                   IF        *in89 = True
     C                   EVAL      ErrorFound = 'Y'
     C                   ENDIF
 
 
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FFPRVL - Convert screen price to file format                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      ** +--- The converted FFPRVLZ4 starts here --------------------------+
      ****************************************************************
      **                                                             *
      **  SR:FFPRVL   - VALIDATES A PRICE IN SCREEN FORMAT           *
      **                ( 16  A ) AND IN DOING SO CONVERTS IT        *    CFF004
      **                INTO ITS EQUIVALENT FILE FORMAT ( 15,8P )    *    CFF004
      **                                                             *
      **  INPUTS      - FFSPRC (16  A) PRICE ( SCREEN FORMAT )       *    CFF004
      **                FFTKDM  (3,0P) TICKS DENOMINATOR             *
      **                FFMNPF (15,8P) MINIMUM PRICE FLUCTUATION     *    CFF004
      **  OUTPUTS     - FFPRIC (15,8P) PRICE ( FILE FORMAT )         *    CFF004
      **                *IN89    (1A)  ERROR IND. (ON IF INVALID)    *
      **                                                             *
      *   LAST AMEND NO. CFF004             DATE 22AUG96             *
      *   PREV AMEND NO. 080988             DATE 11JAN95             *
      *                                                              *
      *--------------------------------------------------------------*
      *                                                              *
      *   CFF004  -  Increase in size of Price Fields                *
      *   080988  -  Price format Delimiter validation extended to   *
      *              check for no '.' if Tick Denominator is not 100 *
      *                                                              *
      ****************************************************************
 
     C     FFPRVL        BEGSR                                                  ** FFPRVL SR **
 
      **    DEFINE INPUT FIELDS
     C                   MOVE      FFSPRC        FFSPRC           16                           CFF00
     C                   Z-ADD     FFTKDM        FFTKDM            3 0
     C                   Z-ADD     FFMNPF        FFMNPF           15 8                         CFF00
 
     C                   SETOFF                                       89
 
      **    INITIALISE O/P FIELD FFPRIC
 
     C                   Z-ADD     0             FFPRIC           15 8                         CFF00
 
      **    NO FURTHER PROCESSING IF FIELD ENTERED IS BLANK
 
     C     FFSPRC        IFNE      *BLANKS
     C                   Z-ADD     0             I                 2 0
     C                   Z-ADD     0             P                                            CFF006
     C                   Z-ADD     0             N                                            CFF006
 
      **   CHECK ARRAY FOR FIRST NON-BLANK CHARACTER
 
     C                   Z-ADD     1             J                 2 0
 
     C     FFSP(J)       DOWEQ     ' '
     C                   ADD       1             J
     C                   END
 
      **   LOOP TO PROCESS NON-BLANK CHARACTERS
 
     C                   Z-ADD     0             FFCNT1            1 0
     C                   Z-ADD     0             FFCNT2            1 0
     C                   Z-ADD     0             FFCNT3            1 0                        CFF006
     C                   MOVE      *BLANK        FFPRDL            1                          CFF006
     C                   Z-ADD     J             K                 2 0
     C     K             DOWLT     17                                                          CFF00
     C     FFSP(K)       ANDNE     ' '
 
      **   IF CHARACTER IS A NUMBER, ADD 1 TO RELEVANT COUNT
 
     C     FFSP(K)       IFGE      '0'
     C     FFSP(K)       ANDLE     '9'
 
     C     I             IFEQ      0
     C                   ADD       1             FFCNT1
     C                   ELSE
      *                                                                                       CFF006
      ** Check that position of the first digit after the second                              CFF006
      ** delimeter is zero before adding 1 to counter 2, otherwise                            CFF006
      ** add 1 to counter 3                                                                   CFF006
      *                                                                                       CFF006
     C     P             IFEQ      0                                                          CFF006
      *                                                                                       CFF006
     C                   ADD       1             FFCNT2
     C                   ELSE                                                                 CFF006
     C                   ADD       1             FFCNT3                                       CFF006
     C                   ENDIF                                                                CFF006
      *                                                                                       CFF006
     C                   END
 
      **   IF COUNT IS TOO HIGH, THERE IS AN ERROR
 
 
     C     FFCNT1        IFGT      7                                                           CFF00
     C     FFCNT2        ORGT      8                                                           CFF00
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
 
     C                   ELSE
 
      **   IF CHARACTER IS A DECIMAL DELIMITER
 
     C     FFSP(K)       IFEQ      '-'
     C     FFSP(K)       OREQ      '.'
      *                                                                                       CFF006
     C     FFTKDM        IFNE      100                                                        CFF006
     C     FFMNPF        ANDNE     *ZEROS                                                     CFF006
      *                                                                                       CFF006
      ** If I is greater than zero means that second delimeter was                            CFF006
      ** encountered and should be validated.  Otherwise, this variable                       CFF006
      ** should contain the position of the first digit after the                             CFF006
      ** first delimeter.  This is for Fractional Ticks processing only.                      CFF006
      *                                                                                       CFF006
     C     I             IFGT      *ZERO                                                      CFF006
     C                   SELECT                                                               CFF006
      *                                                                                       CFF006
     C                   WHEN      P > 0                                                      CFF006
     C                   EVAL      *IN89 = *ON                                                CFF006
     C                   GOTO      FFVEND                                                     CFF006
      *                                                                                       CFF006
     C                   WHEN      FFSP(K) <> '.'                                             CFF006
     C                   EVAL      *IN89 = *ON                                                CFF006
     C                   GOTO      FFVEND                                                     CFF006
      *                                                                                       CFF006
     C                   WHEN      FFSP(K) = '.' AND                                          CFF006
     C                             FFPRDL <> '-'                                              CFF006
     C                   EVAL      *IN89 = *ON                                                CFF006
     C                   GOTO      FFVEND                                                     CFF006
      *                                                                                       CFF006
     C                   OTHER                                                                CFF006
     C                   EVAL      P = K + 1                                                  CFF006
     C                   ENDSL                                                                CFF006
      *                                                                                       CFF006
     C                   ELSE                                                                 CFF006
     C                   EVAL      I = K + 1                                                  CFF006
     C                   MOVE      FFSP(K)       FFPRDL                                       CFF006
      *                                                                                       CFF006
     C                   ENDIF                                                                CFF006
      *                                                                                       CFF006
     C                   ELSE                                                                 CFF006
 
      **   IT IS AN ERROR IF A PREVIOUS DELIMITER HAS BEEN FOUND
 
     C     I             IFGT      0
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   ELSE
     C     K             ADD       1             I
     C                   END
 
      **   IT IS AN ERROR IF IT IS A DASH WHEN FFTKDM = 100
      **               OR IF IT IS A POINT WHEN FFTKDM >< 100             080988
 
     C     FFSP(K)       IFEQ      '-'
     C     FFTKDM        ANDEQ     100
     C     FFSP(K)       OREQ      '.'                                                         08098
     C     FFTKDM        ANDNE     100                                                         08098
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
     C                   ENDIF                                                                CFF006
 
      **   IF CHARACTER IS NEITHER NUMBER OR DELIMITER IT IS AN ERROR
 
     C                   ELSE
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
 
     C                   END
 
      **   IF NO ERROR, CHECK NEXT CHARACTER
 
     C                   ADD       1             K
     C                   END
 
      **   ERROR IF EMBEDDED BLANK IS FOUND
 
     C     K             IFLT      16                                                          CFF00
     C                   MOVE      *BLANKS       FFTEST           15                           CFF00
     C                   MOVEA     FFSP(K)       FFTEST
 
     C     FFTEST        IFNE      *BLANKS
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
 
     C                   END
 
      **   IF BOTH COUNTS ARE 0 IT IS AN ERROR
 
     C     FFCNT1        IFEQ      0
     C     FFCNT2        ANDEQ     0
     C     FFCNT3        ANDEQ     0                                                          CFF006
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
 
      **   IT IS AN ERROR IF TOO MANY CHARACTERS ARE ENTERED AFTER THE
      **   DECIMAL DELIMITER AND TICKS DENOMINATOR ISN'T 100
 
     C     FFTKDM        IFNE      100
 
     C     FFCNT2        IFGE      4
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
 
     C     FFTKDM        IFLE      99
     C     FFTKDM        ANDGE     11
     C     FFCNT2        ANDGE     3
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
 
     C     FFTKDM        IFLE      10
     C     FFTKDM        ANDGE     1
     C     FFCNT2        ANDGE     2
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
      *                                                                                       CFF006
      ** Number of digits after '.' must not exceed 3 digits                                  CFF006
      *                                                                                       CFF006
     C     FFMNPF        IFNE      *ZEROS                                                     CFF006
     C     FFCNT3        ANDGT     3                                                          CFF006
     C                   EVAL      *IN89 = *ON                                                CFF006
     C                   GOTO      FFVEND                                                     CFF006
     C                   ENDIF                                                                CFF006
 
     C                   END
 
      **   SET UP THE 15,8 OUTPUT PRICE - INTEGER COMPONENT               CFF004
 
      **   FFPRIC WAS ZEROISED AT START OF ROUTINE SO IT IS ALREADY
      **   CORRECT IF COUNT1 IS 0
 
     C     FFCNT1        IFNE      0
     C     8             SUB       FFCNT1        L                 2 0                         CFF00
     C                   MOVEA     FFSP(J)       FFIN(L)
     C                   END
 
      **   DECIMAL COMPONENT
 
     C     K             IFLT      17                                                          CFF00
     C                   MOVEA     *ZEROS        FFSP(K)
     C                   END
 
      **   FFPRIC WAS ZEROISED AT START OF ROUTINE SO IT IS ALREADY
      **   CORRECT IF COUNT2 IS 0
 
     C     FFCNT2        IFNE      0
     C                   MOVEA     FFSP(I)       FFDECA
     C                   END
 
      **   ADJUST DECIMAL COMPONENT TO ALLOW FOR MISSING LEADING
      **   ZEROS IF TICKS DENOMINATOR ISN'T 100
 
     C     FFTKDM        IFNE      100
      *                                                                                       CFF006
     C     FFMNPF        IFNE      *ZEROS                                                     CFF006
      *                                                                                       CFF006
      ** Move the decimal part of the price to an array variable so                           CFF006
      ** that it will contain the exact decimal part without the                              CFF006
      ** delimeter.                                                                           CFF006
      *                                                                                       CFF006
     C                   EVAL      N = FFCNT2 + 8                                             CFF006
     C                   MOVEA     FFDECA        FFAR(8)                                      CFF006
     C     P             IFNE      *ZERO                                                      CFF006
     C                   MOVEA     FFSP(P)       FFAR(N)                                      CFF006
     C                   ENDIF                                                                CFF006
     C                   MOVEA     FFAR(8)       FFDECA                                       CFF006
      *                                                                                       CFF006
      ** Extract the correct decimal figures to be used later                                 CFF006
      ** to check if the decimal part of the price is an exact                                CFF006
      ** multiple of the minimum price fluctuation                                            CFF006
      *                                                                                       CFF006
     C                   SELECT                                                               CFF006
      *                                                                                       CFF006
     C                   WHEN      FFCNT2 = 3                                                 CFF006
     C                   EVAL      FFDCDP = FFDECD/100000                                     CFF006
      *                                                                                       CFF006
     C                   WHEN      FFCNT2 = 2                                                 CFF006
     C                   EVAL      FFDCDP = FFDECD/1000000                                    CFF006
      *                                                                                       CFF006
     C                   WHEN      FFCNT2 = 1                                                 CFF006
     C                   EVAL      FFDCDP = FFDECD/10000000                                   CFF006
      *                                                                                       CFF006
     C                   WHEN      FFCNT2 = 0                                                 CFF006
     C                   EVAL      FFDCDP = FFDECD/100000000                                  CFF006
      *                                                                                       CFF006
     C                   OTHER                                                                CFF006
     C                   EVAL      *IN89 = *ON                                                CFF006
     C                   GOTO      FFVEND                                                     CFF006
     C                   ENDSL                                                                CFF006
      *                                                                                       CFF006
     C     FFCNT2        IFEQ      0                                                          CFF006
      *                                                                                       CFF006
     C                   SELECT                                                               CFF006
      *                                                                                       CFF006
      ** Divide by 10 if between 1 and 9 and one zero missing                                 CFF006
      *                                                                                       CFF006
     C                   WHEN      FFTKDM <= 9 AND                                            CFF006
     C                             FFTKDM >= 1                                                CFF006
     C     FFDECD        DIV       10            FFDECD                                       CFF006
      *                                                                                       CFF006
      ** Divide by 100 if between 11 and 99 and two zeroes missing                            CFF006
      *                                                                                       CFF006
     C                   WHEN      FFTKDM <= 99 AND                                           CFF006
     C                             FFTKDM >= 10                                               CFF006
     C     FFDECD        DIV       100           FFDECD                                       CFF006
      *                                                                                       CFF006
      ** Divide by 1000 if between 100 and 999 and three zeros missing                        CFF006
      *                                                                                       CFF006
     C                   WHEN      FFTKDM <= 999 AND                                          CFF006
     C                             FFTKDM >= 101                                              CFF006
     C     FFDECD        DIV       1000          FFDECD                                       CFF006
      *                                                                                       CFF006
     C                   ENDSL                                                                CFF006
     C                   ENDIF                                                                CFF006
      *                                                                                       CFF006
     C                   ENDIF                                                                CFF006
 
      **   DIVIDE BY 10 IF BETWEEN 11 & 99 AND ONE ZERO MISSING
 
     C     FFTKDM        IFLE      99
     C     FFTKDM        ANDGE     11
     C     FFCNT2        ANDEQ     1
     C     FFDECD        DIV       10            FFDECD
     C                   END
 
      **   DIVIDE BY 10 IF BETWEEN 100 & 999 AND ONE ZERO MISSING
 
     C     FFTKDM        IFLE      999
     C     FFTKDM        ANDGE     101
     C     FFCNT2        ANDEQ     2
     C     FFDECD        DIV       10            FFDECD
     C                   END
 
      **   DIVIDE BY 100 IF BETWEEN 100 & 999 AND TWO ZEROS MISSING
 
     C     FFTKDM        IFLE      999
     C     FFTKDM        ANDGE     101
     C     FFCNT2        ANDEQ     1
     C     FFDECD        DIV       100           FFDECD
     C                   END
 
     C                   END
 
      **   IF TICKS DENOMINATOR IS 100 THE PRICE MUST BE AN EXACT
      **   MULTIPLE OF THE MINIMUM PRICE FLUCTUATION
 
     C     FFTKDM        IFEQ      100
     C     FFPRIC        DIV       FFMNPF        FFCHK1           15 0                         CFF00
     C                   MVR                     FFCHK2           15 8                         CFF00
 
     C     FFCHK2        IFNE      *ZERO
     C                   SETON                                            89
     C                   GOTO      FFVEND
     C                   END
 
      **   IF IT ISN'T, THE PRICE AFTER THE DECIMAL POINT MUST BE LESS
      **   THAN THE TICKS DENOMINATOR
 
     C                   ELSE
      *                                                                                       CFF006
      ** If Fractional Ticks enhancement is installed, the price after                        CFF006
      ** '-' must be an exact multiple of the minimum price fluctuation                       CFF006
      *                                                                                       CFF006
     C     FFMNPF        IFNE      *ZEROS                                                     CFF006
     C     FFDCDP        DIV       FFMNPF        FFCHK1                                       CFF006
     C                   MVR                     FFCHK2                                       CFF006
      *                                                                                       CFF006
     C     FFCHK2        IFNE      *ZEROS                                                     CFF006
     C                   EVAL      *IN89 = *ON                                                CFF006
     C                   GOTO      FFVEND                                                     CFF006
     C                   ENDIF                                                                CFF006
      *                                                                                       CFF006
     C                   ELSE                                                                 CFF006
     C                   MOVEA     *ZEROS        FFDC
 
      **   MOVE THE SIGNIFICANT CHARACTERS INTO A DATA STRUCTURE
 
     C     FFCNT2        IFNE      0
     C     4             SUB       FFCNT2        L
     C                   MOVEA     FFSP(I)       FFDC(L)
     C                   END
     C                   MOVEA     FFDC          FFTSTC            3
     C                   MOVE      FFTSTC        FFTSTD            3 0
 
      **   ERROR IF THE VALUE IS TOO HIGH
 
     C     FFTSTD        IFGE      FFTKDM
     C                   SETON                                            89
     C                   END
     C                   ENDIF                                                                CFF006
 
     C                   END
 
      **   ZEROISE OUTPUT FIELD IF ERROR OCCURRED
 
     C     FFVEND        TAG                                                    * FFVEND TAG *
     C     *IN89         IFEQ      '1'
     C                   MOVE      *ZERO         FFPRIC
     C                   END
 
     C                   END
 
     C                   ENDSR
      ** +--- The converted FFPRVLZ4 ends here ----------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters rerturned to caller
      ** ------------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** File version of price (15,8P)
     C                   PARM                    FilePrice
 
      ** Parameters received from caller
      ** -------------------------------
      ** Screen version of price (16A)
     C                   PARM                    ScreenPric
      ** Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minmum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
 
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
