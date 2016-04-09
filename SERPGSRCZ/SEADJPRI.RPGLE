     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Adjust trade price (CSE037)')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading                                     *
      *                                                               *
      *  SEADJPRI - Adjust Trade Price for CSE037                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CSE071             Date 19Jul05               *
      *                 CSE037  *CREATE    Date 29Apr02               *
      *                                                               *
      *****************************************************************
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE037 - Incorporate Australian Modification AUS053 -        *
      *           Countervalue Rounding - into core.                  *
      *****************************************************************
      *
      ** Security details
     FSECTY     IF   E           K DISK
      *
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      *
     D                 DS
     D FAC                            8  0 DIM(8) PERRCD(1) CTDATA              Factor Array
 
     D P@FMT         E DS                  EXTNAME(DSSDY)
      * EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT
      * OF THE FILE.
      *
     D P@SESN          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
     D  W@SL04                 4      4
     D  W@SL05                 5      5
     D  W@SL06                 6      6
     D  W@SL07                 7      7
     D  W@SL08                 8      8
     D  W@SL09                 9      9
     D  W@SL10                10     10
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** SAR Fields
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      ************************************************************
      /EJECT
      ************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   EXSR      ZNDEC
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************************
      **                                                             **
      ** ZNDEC  - SUBROUTINE TO ADJUST THE NO. OF DECIMAL PLACES     **
      **                                                             **
      ** INPUT  - ZINPF  (15,8) Amount to be adjusted                **
      **          ZSESN  (10A)  Security shortname                   **
      **                                                             **
      ** OUTPUT - ZOUTF  (15,8) Adjusted amount                      **
      **                                                             **
      ** NOTE   - Should only be called for price/interest           **
      **          adjustments for Securities Trading.                **
      **          SECTY should have been read prior to executing     **
      **          this subroutine.                                   **
      **                                                             **
      *****************************************************************
     C     ZNDEC         BEGSR
      *
      ** Get Security details
      *
     C     P@SESN        CHAIN     SECTYDF                            44
      *
      ** Initialise output field
      *
     C                   Z-ADD     *ZEROS        P@OUAM
      *
      * If no record found, use a standard of 8
      *
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVE      8             WDC
     C                   ELSE
     C                   MOVE      NDEC          WDC               1 0
     C                   END
      *
      * If number of decimal places not equal to 8 then decimal places
      * for price must be adjusted
      *
     C     WDC           IFNE      8
     C                   ADD       1             WDC
     C     P@INAM        MULT(H)   FAC(WDC)      WRKFLD           15 0
     C     WRKFLD        DIV       FAC(WDC)      P@OUAM
     C                   ELSE
     C                   Z-ADD     P@INAM        P@OUAM
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE035
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Security Details  (Shortname)
      ** ----------------
     C                   PARM                    P@SESN           10
 
      ** Amounts (input and output)
      ** -------
     C                   PARM                    P@INAM           15 8          I:Amount
     C                   PARM                    P@OUAM           15 8          O:Amount
 
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
** CPY@
(c) Misys International Banking Systems Ltd. 2002
** FAC
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
