     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF convert price from file to screen format')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFPRCS - Convert FF price from file to screen format         *
      *                                                               *
      *  Function:  This module is a conversion of the external       *
      *             subroutine FFPRCS, comprising the 3 /COPY members *
      *             FFPRCSZ2, FFPRCSZ3 and FFPRCSZ4.                  *
      *             Note that if any change needs to be done it       *
      *             should be applied to the /COPY members and they   *
      *             should be reconverted to replace this module.     *
      *             The function is to convert the file version of a  *
      *             price to a 16A screen format.  For the full       *
      *             details see the member FFPRCSZTXT in ZSRSRC.      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CFF006             Date 28Nov00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      ** arrays for FF, including the named constant giving the size of
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
 
     D Price           DS
      ** Signed versions of price to allow MOVEA
     D  SignedPric             1     15S 8
     D  SignedPArr             1     15S 0 DIM(15)
 
     ** *--------------------*
     ** | Note on conversion |
     ** *--------------------*----------------------------------------------
     ** Note that the two members FFPRCSZ2 and FFPRCSZ3 were merged
     ** before being converted to ILE RPG, so that both the E- and I-specs
     ** could be properly converted to D-specs.
     ** --------------------------------------------------------------------
     ** +--- The converted, merged FFPRCSZ2 and FFPRCSZ3 start here -------+
 
     D FFFP            S              1  0 DIM(15)
 
     D                 DS
 
      **   FFSPRC ( Screen Format of Price )
     D  FFSP                   1     16
     D                                     DIM(16)
     D  FFSPRC                 1     16
     D                 DS
 
      **   Minimum Price Fluctuation
     D  FFMF                   8     15  0
     D                                     DIM(8)
     D  FFMNPF                 1     15  8
      * +--- The converted, merged FFPRCSZ2 and FFPRCSZ3 end here ---------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Minimum price fluctuation
     D MinPrcFluc      S             15P 8
 
      ** Screen version of price
     D ScreenPric      S                   LIKE(FFSPRC)
                                                                                              CFF006
      ** Work variable used for Fractional ticks enhancement                                  CFF006
     D K               S              2  0                                                    CFF006
     D L               S              2  0                                                    CFF006
     D P               S              2  0                                                    CFF006
     D FFPT2           S              1A                                                      CFF006
     D FFEXPT2         S              1A                                                      CFF006
     D FFSIGN          S              1A                                                      CFF006
 
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
 
      ** Set the subroutine's version of the minimum price fluctuation to
      ** the parameter value received
     C                   EVAL      FFMNPF = MinPrcFluc
 
      ** Put the file version of the price into its array equivalent
     C                   EVAL      SignedPric = FFPRIC
     C                   MOVEA     SignedPArr    FFFP
 
     C                   EXSR      FFPRCS
 
      ** Set the output screen version of the price to the calculated
      ** value
     C                   EVAL      ScreenPric = FFSPRC
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FFPRCS - Convert file price to screen format                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      ** +--- The converted FFPRCSZ4 starts here --------------------------+
      **                                                             *
      **  SR:FFPRCS   - CONVERTS A PRICE IN FILE FORMAT ( 15,8P )    *
      **                TO ITS EQUIVALENT SCREEN FORMAT ( 16  A )    *
      **                                                             *
      **  INPUTS      - FFPRIC (15,8P) PRICE ( FILE FORMAT )         *
      **                FFTKDM  (3,0P) TICKS DENOMINATOR             *
      **                FFMNPF (11,7P) MINIMUM PRICE FLUCTUATION     *
      **  OUTPUTS     - FFSPRC (16  A) PRICE ( SCREEN FORMAT )       *
      **                                                             *
      ****************************************************************
      *                                                               *
      *  LAST AMEND NO. CFF004             DATE 21AUG96               *
      *  PREV AMEND NO. XXXXXX             DATE DDMMMYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      * CFF004 - Increase in size of Price Fields                     *
      *                                                               *
      *****************************************************************
 
     C     FFPRCS        BEGSR                                                  ** FFPRCS SR **
 
      *     DEFINE INPUT FIELDS
     C                   Z-ADD     FFPRIC        FFPRIC           15 8
     C                   Z-ADD     FFTKDM        FFTKDM            3 0
     C                   Z-ADD     FFMNPF        FFMNPF           15 8
     C                   EVAL      K = 0                                                      CFF006
     C                   EVAL      FFSIGN = 'N'                                               CFF006
     C                   EVAL      FFEXPT2 = 'N'                                              CFF006
 
      *     INITIALISE O/P FIELD FFSPRC
 
     C                   MOVE      *BLANK        FFSPRC           16
 
      *     SEARCH FFPRIC FOR 1ST NON ZERO ELEMENT BEFORE DECIMAL
 
     C                   Z-ADD     1             I                 2 0
     C     I             DOWLT     7
     C     FFFP(I)       ANDEQ     0
 
     C                   ADD       1             I
 
     C                   END
 
      *     MOVE ELEMENTS FROM FIRST NON ZERO POSITION TO 7TH OF FFFP
      *     TO CORRESPONDING POSITIONS IN FFSP
 
     C     I             DOWLE     7
 
     C                   MOVE      FFFP(I)       FFSP(I)
     C                   ADD       1             I
 
     C                   END
 
      *     SET UP DECIMAL OR FRACTION FORMAT SEPARATOR
 
     C     FFTKDM        IFEQ      100
 
     C                   MOVE      '.'           FFPT              1
 
     C                   ELSE
 
     C                   MOVE      '-'           FFPT
      *                                                                                       CFF006
     C                   IF        FFMNPF <> 0                                                CFF006
     C                   MOVE      '.'           FFPT2                                        CFF006
     C                   ENDIF                                                                CFF006
 
     C                   END
 
      *     DETERMINE NUMBER OF SIGNIFICANT DECIMAL DIGITS
 
      *     IF TICK =100 DETERMINE NO. DECIMAL PLACES FROM FFMNPF
 
     C     FFTKDM        IFEQ      100
 
     C                   Z-ADD     8             I
     C     I             DOWGT     0
     C     FFMF(I)       ANDEQ     0
 
     C                   SUB       1             I
 
     C                   END
     C                   Z-ADD     I             FFN               2 0
 
     C                   ELSE
 
      *    DETERMINE NO. OF SIGNIFICANT DIGITS FROM TICK VALUE
 
     C     FFTKDM        IFLE      10
     C                   Z-ADD     1             FFN
     C                   END
 
     C     FFTKDM        IFGT      10
     C     FFTKDM        ANDLE     100
     C                   Z-ADD     2             FFN
     C                   END
 
     C     FFTKDM        IFGT      100
     C                   Z-ADD     3             FFN
     C                   END
 
     C                   END
      *                                                                                       CFF006
      ** Determine the total number of fractional digits.  If this is                         CFF006
      ** greater than the significant digits before the '.', then                             CFF006
      ** second delimeter is required.                                                        CFF006
      *                                                                                       CFF006
     C                   IF        FFTKDM <> 100 AND                                          CFF006
     C                             FFMNPF <> 0                                                CFF006
      *                                                                                       CFF006
     C                   Z-ADD     15            I                                            CFF006
      *                                                                                       CFF006
     C                   DOW       I > 7  AND                                                 CFF006
     C                             FFFP(I) = 0                                                CFF006
     C                   EVAL      I = I - 1                                                  CFF006
     C                   ENDDO                                                                CFF006
      *                                                                                       CFF006
     C                   EVAL      L = I - 7                                                  CFF006
      *                                                                                       CFF006
     C                   IF        L > 0                                                      CFF006
     C                   IF        L > FFN                                                    CFF006
     C                   EVAL      FFEXPT2 = 'Y'                                              CFF006
     C                   ELSE                                                                 CFF006
     C                   Z-ADD     FFN           L                                            CFF006
     C                   ENDIF                                                                CFF006
     C                   ENDIF                                                                CFF006
      *                                                                                       CFF006
     C                   ENDIF                                                                CFF006
 
      *    IF NUMBER OF SIGNIFICANT DECIMALS<> 0
 
     C     FFN           IFNE      0
 
      *    MOVE FFPT IN TO OUT FIELD
 
     C                   MOVE      FFPT          FFSP(8)
      *                                                                                       CFF006
      ** Move the fractional digits to out field                                              CFF006
      *                                                                                       CFF006
     C                   IF        FFTKDM <> 100 AND                                          CFF006
     C                             FFMNPF <> 0                                                CFF006
     C                   EVAL      I = 8                                                      CFF006
     C                   EVAL      J = 9                                                      CFF006
     C                   EVAL      P = 1                                                      CFF006
     C                   EVAL      FFSIGN = 'N'                                               CFF006
      *                                                                                       CFF006
     C                   DOW       P <= L                                                     CFF006
      *                                                                                       CFF006
      ** If digit is not zero, or if it is zero but significant,                              CFF006
      ** (meaning a previous non-zero digit were previously moved)                            CFF006
      ** move this to out field                                                               CFF006
      *                                                                                       CFF006
     C                   IF        FFFP(I) <> 0  OR                                           CFF006
     C                             FFSIGN = 'Y'  OR                                           CFF006
     C                             FFFP(I) = 0   AND                                          CFF006
     C                             FFSIGN <> 'Y' AND                                          CFF006
     C                             P = FFN                                                    CFF006
     C                   MOVE      FFFP(I)       FFSP(J)                                      CFF006
     C                   EVAL      FFSIGN = 'Y'                                               CFF006
     C                   EVAL      J = J + 1                                                  CFF006
     C                   ENDIF                                                                CFF006
      *                                                                                       CFF006
      ** If significant digits before '.' has been moved, and second                          CFF006
      ** delimeter is necessary, move the delimeter to out field                              CFF006
      *                                                                                       CFF006
     C                   EVAL      I = I + 1                                                  CFF006
     C                   IF        FFN = P AND                                                CFF006
     C                             FFEXPT2 = 'Y'                                              CFF006
     C                   EVAL      FFSP(J) = FFPT2                                            CFF006
     C                   EVAL      J = J + 1                                                  CFF006
     C                   ENDIF                                                                CFF006
      *                                                                                       CFF006
     C                   EVAL      P = P + 1                                                  CFF006
     C                   ENDDO                                                                CFF006
      *                                                                                       CFF006
     C                   ELSE                                                                 CFF006
 
      *    MOVE SIGNIFICANT DIGITS TO CORRESPONDING
      *    POSITIONS IN FFSP
 
     C                   Z-ADD     8             I
     C     FFN           DOWNE     0
 
     C     I             ADD       1             J                 2 0
     C                   MOVE      FFFP(I)       FFSP(J)
     C                   ADD       1             I
     C                   SUB       1             FFN
 
     C                   END
     C                   ENDIF                                                                CFF006
 
     C                   END
 
     C                   ENDSR
 
      ********************************************************************
      ** +--- The converted FFPRCSZ4 ends here ----------------------------+
 
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
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Screen version of price (16A)
     C                   PARM                    ScreenPric
 
      ** Parameters received from caller
      ** -------------------------------
      ** File version of price (15,8P)
     C                   PARM                    FFPRIC
      ** Tick denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    MinPrcFluc
 
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
(c) Finastra International Limited 2001
