     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans Display 4')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP4DP - LE Customer Loans Display                        *
      *                                                               *
      *  Function:  This module displays the fourth details screen    *
      *             of the Customer Loans screen input function.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 246178             Date 01Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10574           Date 02Mar06               *
      *                 CAP074  *CREATE    Date 29Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246178 - Could not display message other than GBLERMSGF      *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
     FLECLIP4DDFCF   E             WORKSTN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
      * This array has been reduced as error indicators do not go up to 70 to free additional inds
      * NOTE: Array at bottom of code has been reduced but cannot be commented
     D @Z0             S              1    DIM(50) CTDATA PERRCD(50)
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
      *
     D @EI             S              1    DIM(60)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, SHORT data structure
      *
     D Clip04        E DS                  EXTNAME(LECLI4PD)
     D OKClip04      E DS                  EXTNAME(LEECLI4PD)
      *
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      **   Initial processing
      *
     C                   EXSR      INIT
      *
      ***  Main processing
      *
     C                   EXSR      MAIN
      *
      ***  Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT  - Initial processing                                    *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Check type of processing
      *
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      '1'           *IN82
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      '1'           *IN83
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing                                        *
      *****************************************************************
     C     MAIN          BEGSR
      *
      ***  Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKClip04      @EI
      *
      ***  Initialize action code
      ***  Set the action code to 'E' in case of action code '3'
      *
     C     PActionCode   IFEQ      '4'
     C                   MOVEL     'E'           DDACT4
     C                   ELSE
     C                   MOVEL     PActionCode   DDACT4
     C                   END
      *
      ***  Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      ***  Do while error messages found
      ***  write error messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZMSID
     C                   MOVEL     MsgDtaArr(C)  ZMSDA
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   END
      *
      ***  Do while warning messages found
      ***  Write warning messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZMSID
     C                   MOVEL     WMsgDtaArr(C) ZMSDA
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   END
      *
      ***  Enable detail fields (all fields except action code & loan number)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      ***  Enable function keys
      *
     C     @EINKI        COMP      'Y'                                    75    F09
     C     @EINKJ        COMP      'Y'                                    76    F10
     C     @EINKN        COMP      'Y'                                    72    F14
      *
      ***  Text = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANKS       DDFOTX
     C                   END
      *
      ***  Write message sub-file, details and footer screen
      *
     C                   WRITE     LECLIPC4
     C                   WRITE     LECLIPD4
     C                   WRITE     LECLIPF4
      *
      ***  Read details screen,
      *
      ***  If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      LECLIPD4                               99    *
     C                   ENDIF
      *
      ***  If rolldown set F12 to on
      *
     C     *IN78         IFEQ      '1'
     C                   MOVE      '1'           *INKL
     C                   MOVE      '1'           @PGUP
     C                   ENDIF
      *
      ***  Clear message subfile
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
      ***  Set screen error indicators OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ***  Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKI         @INKI
     C                   MOVE      *INKJ         @INKJ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ERRMSG  - Output error messages                               *
      *****************************************************************
     C     ERRMSG        BEGSR
      *
      ***  Display error message
      *** 246178 - in Input message could be LERMSGF, Y2USRMSG or DRSMM and XXUSRMSG          246178
      *                                                                                       246178
     C                   Z-ADD     1             Index             1 0                        246178
     C                   DoW       Index < 5                                                  246178
     C                   SELECT                                                               246178
     C     Index         WhenEq    1                                                          246178
     C                   Movel(p)  'GBLERMSGF'   ZMSGF                                        246178
     C     Index         WhenEq    2                                                          246178
     C                   Movel(p)  'GBDRSMM'     ZMSGF                                        246178
     C     Index         WhenEq    3                                                          246178
     C                   Movel(p)  'GBY2USRMSG'  ZMSGF                                        246178
     C     Index         WhenEq    4                                                          246178
     C                   Movel(p)  'GBXXUSRMSG'  ZMSGF                                        246178
     C                   ENDSL                                                                246178
      *                                                                                       246178
     C                   CALL      'SDRTVTXT'                                                 246178
     C                   PARM                    ZMSID                                        246178
     C                   PARM                    ZMSGF                                        246178
     C                   PARM      *blanks       MSGTXT           80                          246178
     C                   if        %subst(MSGTXT:1:18) <>                                     246178
     C                             'Text not available'                                       246178
     C                             and MSGTXT <> *BLANKS                                      246178
     C                   Z-ADD     9             index                                        246178
     C                   Else                                                                 246178
     C                   Eval      Index = Index +1                                           246178
     C                   Endif                                                                246178
     C                   EndDo                                                                246178
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LECLIP4DP'   ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZMSID             7            Message Id.
     C                   PARM                    ZMSGF                          Message file.
     C                   PARM                    ZMSDA           132            Message data.
     C                   PARM                    ZMSTP             7            Message type.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing.                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM                    RetCodeIn
      *
      ***  Loan (in screen format)
     C                   PARM                    Clip04
      *
      ***  Fields in error
     C                   PARM                    OKClip04
      *
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKI            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
      *
      ***  Calling type
      *
     C                   PARM                    LoanType          4
      *
      ***  Action code
      *
     C                   PARM                    PActionCode       1
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @PGUP             1
      *
      ***  Write screen with no read indicator
      *
     C                   PARM                    WriteOnly         1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP4DP'   DBPGM
      *
      ***  Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'GBLERMSGF'   ZMSGF            10
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** @Z0
00000000000000000000000000000000000000000000000000
** @NAR
Loan No. 999999 successfully inserted.
F10=CONFIRM DELETE
