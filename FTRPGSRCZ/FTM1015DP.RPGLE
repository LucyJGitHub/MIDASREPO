     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Input, maint and view RFT header records')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1015DP - FUNDS TRANSFER REQUEST FOR TRANSFER/MT101        *
      *              AND MT102 DISPLAY MODULE                         *
      *                                                               *
      *  Function:  This module provides the functionality for the    *
      *             input, maintenance, authorise and enquiry of the  *
      *             RFT header details screen.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022652           Date 07Oct13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 08Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178384             Date 28Apr00               *
      *                 CFT007             Date 21Mar00               *
      *                 CFT006  *CREATE    Date 21Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022652 - Excluded Phase Processing                         *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Incorrect routing of multiple MT101s. Use new field *
      *           RSEQNO in FTH101PD as Sender's Ref Routing Seq.     *
      *  188649 - Add authorised description to team                  *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  178384 - F11 not displayed on header 102 second screen       *
      *  CFT007 - BIC Database Plus                                   *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Screen file for header details
     FFTM1015DDFCF   E             WORKSTN
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      *****************************************************************
      *                                                               *
      *     FUNCTION OF INDICATORS                                    *
      *     **********************                                    *
      *                                                               *
      *     15 -  Disable/hide refresh key                            *
      *     16 -  Disable/hide delete key                             *
      *     20 -  Display header for incoming messages                *
      *     21 -  Display header for outgoing messages                *
      *     25 -  Protect fields                                      *
      *     26 -  Protect senders reference field                     *
      *     27 -  Display F11 - user                                  *         CFT007
      *     28-51 Field in Error - highlight screen fields            *
      *                                                               *
      *     Enable CF03 - Exit                                        *
      *     Enable CF05 - Refresh                                     *
      *     Enable CF10 - Delete/Confirm                              *
      *     Enable CF11 - Show Audit Details                          *
      *     Enable CF12 - Cancel                                      *
      *                                                               *
      *       76  Hide BIC search key                                 *         CFT007
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  BIC Database Plus                                   *         CFT007
      *                                                               *
      *****************************************************************
      *                                                               *
      *     SUBROUTINES                                               *
      *     ***********                                               *
      *                                                               *
      *     *INZSR - Initial subroutine called on first time entry    *
      *     INITIAL- Initial subroutine every time module is called   *
      *     MAIN   - Processes screen for display                     *
      *     CLEAR  - Clears error message processing                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
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
      **
      **-----------------------------------------------------------------   ------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the FT standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      **
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
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
 
      ** +---------------------------+
      ** ¦ Data Structures           ¦
      ** ¦ ===============           ¦
      ** +---------------------------+
 
     D Sdbank        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D Sdgelr        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D Sdmmod        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D Scsard        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D Dsfdy         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D Dssdy         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      *
      ** General details screen physical file
     D Ft101hs       E DS                  EXTNAME(FT101HSPD)
      *
      ** Header record details
     D HdrRcdIn      E DS                  EXTNAME(FT101HPD)
      *
      ** OK Header record flags
     D OKHdr         E DS                  EXTNAME(FTE101HPD)
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      *
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** INDEXS
      ** ------
      ** Number of Fields on the screen
     D NBFIELDS        C                   Const(25)
      *
     D q               S              2  0
      *
      ** Work fields
     D PACTN           S                   LIKE(@Actn)
      *
     D WACTN           S                   LIKE(@Actn)
     D WRFTID          S                   LIKE(PRFTID)
     D WPTYP           S                   LIKE(PPTYP)
     D WPYST           S                   LIKE(PPYST)
     D WSNDREF         S                   LIKE(PSNDREF)
     D WCUSTRF         S                   LIKE(PCUSTRF)
     D WBRCA           S                   LIKE(PBRCA)
     D WORBR           S                   LIKE(PORBR)
     D WBOKC           S                   LIKE(PBOKC)
     D WPRFC           S                   LIKE(PPRFC)
     D WSWPRIO         S                   LIKE(PSWPRIO)
     D WHINPTY         S                   LIKE(PHINPTY)
     D WRFTDST         S                   LIKE(PRFTDST)
     D WHOCUS1         S                   LIKE(PHOCUS1)
     D WHOCUS2         S                   LIKE(PHOCUS2)
     D WHOCUS3         S                   LIKE(PHOCUS3)
     D WHOCUS4         S                   LIKE(PHOCUS4)
     D WHOCUS5         S                   LIKE(PHOCUS5)
     D WHACSV1         S                   LIKE(PHACSV1)
     D WHACSV2         S                   LIKE(PHACSV2)
     D WDBTVDT         S                   LIKE(PDBTVDT)
     D WEXDATE         S                   LIKE(PEXDATE)
     D WHANDCG         S                   LIKE(PHANDCG)
     D WHANDCY         S                   LIKE(PHANDCY)
     D WHANDAC         S                   LIKE(PHANDAC)
     D WSINST          S                   LIKE(PSINST)
     D WAUTHTX         S                   LIKE(PAUTHTX)
      *
      ** Index for arrays of error message ids etc
     D @MemF           S              1A
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** PARAMETERS
      ** ----------
 
      ** Function key pressed
     D @KeyP           S              2
 
      ** Parameters for ZA0920
     D RtnCod          S             10
     D AmtN13D0        S             13  0
     D Qecn            S              1  0
     D BndCsp          S              1    Inz('.')
     D AmtA14          S             14
 
      ** ARRAYS
      ** ------
      *
      * Array of subroutines stack
     D SrStack         S             15    DIM(30)
      *
     D @IndOff         S              1    DIM(30) CTDATA PERRCD(30)
      *
     D @FldErArr       S              1    DIM(NBFIELDS)
 
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
      *
      ** Main processing
      *
      **  Set up subroutine stack name
     C                   ADD       1             q
     C                   MOVEA     'Begin'       SrStack(q)
      *
      ** Initial subroutine called each time module is called
      *
     C                   EXSR      INITIAL
      *
      ** Display screen and error messages
      *
     C                   EXSR      MAIN
      *
     C                   SELECT
      *
      ** If F3 pressed
      *
     C                   WHEN      *Inkc = *ON
     C                   EVAL      @KeyP = '03'
      *
      ** Memorise fields on re-entry to screen
      *
     C                   EVAL      @MemF = 'Y'
      *                                                                         CFT007
      ** If F4 pressed, call BIC database + modules                             CFT007
      *                                                                         CFT007
     C                   WHEN      *Inkd = *ON                                  CFT007
     C                   EVAL      @KeyP = '04'                                 CFT007
     C                   Exsr      MovPart                                      CFT007
      *                                                                         CFT007
      ** If F16 pressed, call BIC database + modules                            CFT007
      *                                                                         CFT007
     C                   WHEN      *Inkq = *ON                                  CFT007
     C                   EVAL      @KeyP = '16'                                 CFT007
     C                   Exsr      MovPart                                      CFT007
      *
      ** If F5 pressed (refresh screen back to original format)
      *
     C                   WHEN      *Inke = *ON
     C                   EVAL      @KeyP = '05'
      *
      ** Move saved work fields back into screen file fields
      *
     C                   MOVEL     WACTN         PACTN
     C                   MOVEL     WRFTID        PRFTID
     C                   MOVEL     WPTYP         PPTYP
     C                   MOVEL     WPYST         PPYST
     C                   MOVEL     WSNDREF       PSNDREF
     C                   MOVEL     WCUSTRF       PCUSTRF
     C                   MOVEL     WBRCA         PBRCA
     C                   MOVEL     WORBR         PORBR
     C                   MOVEL     WBOKC         PBOKC
     C                   MOVEL     WPRFC         PPRFC
     C                   MOVEL     WSWPRIO       PSWPRIO
     C                   MOVEL     WHINPTY       PHINPTY
     C                   MOVEL     WHOCUS1       PHOCUS1
     C                   MOVEL     WHOCUS2       PHOCUS2
     C                   MOVEL     WHOCUS3       PHOCUS3
     C                   MOVEL     WHOCUS4       PHOCUS4
     C                   MOVEL     WHOCUS5       PHOCUS5
     C                   MOVEL     WHACSV1       PHACSV1
     C                   MOVEL     WHACSV2       PHACSV2
     C                   MOVEL     WDBTVDT       PDBTVDT
     C                   MOVEL     WEXDATE       PEXDATE
     C                   MOVEL     WHANDCG       PHANDCG
     C                   MOVEL     WHANDCY       PHANDCY
     C                   MOVEL     WHANDAC       PHANDAC
     C                   MOVEL     WSINST        PSINST
     C                   MOVEL     WAUTHTX       PAUTHTX
     C                   MOVEL     WRFTDST       PRFTDST
      *
      ** If F11 pressed
      *
     C                   WHEN      *Inkk = *ON
     C                   If        @Actn = 'E'
     C                   If        @KeyP = '11'
     C                   Eval      @KeyP = *Blanks
     C                   Else
     C                   EVAL      @KeyP = '11'
     C                   Endif
     C                   Endif
      *
      ** If F12 pressed
      *
     C                   WHEN      *Inkl = *ON
     C                   EVAL      @KeyP = '12'
      *
      ** Memorise fields on re-entry to screen
      *
     C                   EVAL      @MemF = 'Y'
      *
      ** If F10 pressed
      *
     C                   WHEN      *Inkj = *ON
     C                   EVAL      @KeyP = '10'
      *
     C                   OTHER
      *
      ** Enter is pressed, so validate screen  fields
      *
     C                   EVAL      @KeyP = *BLANK
      *
      ** Mapping screen fields to file for validation
      *
     C                   MOVEL     SACTN         PACTN
     C                   MOVEL     SRFTID        PRFTID
     C                   MOVEL     SPTYP         PPTYP
     C                   MOVEL     SPYST         PPYST
     C                   MOVEL     SSNDREF       PSNDREF
     C                   MOVEL     SCUSTRF       PCUSTRF
     C                   MOVEL     SBRCA         PBRCA
     C                   MOVEL     SORBR         PORBR
     C                   MOVEL     SBOKC         PBOKC
     C                   MOVEL     SPRFC         PPRFC
     C                   MOVEL     SSWPRIO       PSWPRIO
     C                   MOVEL     SHINPTY       PHINPTY
     C                   MOVEL     SHOCUS1       PHOCUS1
     C                   MOVEL     SHOCUS2       PHOCUS2
     C                   MOVEL     SHOCUS3       PHOCUS3
     C                   MOVEL     SHOCUS4       PHOCUS4
     C                   MOVEL     SHOCUS5       PHOCUS5
     C                   MOVEL     SHACSV1       PHACSV1
     C                   MOVEL     SHACSV2       PHACSV2
     C                   MOVEL     SDBTVDT       PDBTVDT
     C                   MOVEL     SEXDATE       PEXDATE
     C                   MOVEL     SHANDCG       PHANDCG
     C                   MOVEL     SHANDCY       PHANDCY
     C                   MOVEL     SHANDAC       PHANDAC
     C                   MOVEL     SSINST        PSINST
     C                   MOVEL     SAUTHTX       PAUTHTX
     C                   MOVEL     SRFTDST       PRFTDST
      *
     C                   ENDSL
      *
     C                   MOVEL     PACTN         @Actn
     C                   MOVEL     PPTYP         @RftTyp
      *
      **  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
      *
     C                   RETURN
      *
      *****************************************************************         CFT007
      /EJECT                                                                    CFT007
      *****************************************************************         CFT007
      * MovPart                                                                 CFT007
      *                                                                         CFT007
      * Called by Main                                                          CFT007
      *****************************************************************         CFT007
     C     MovPart       Begsr                                                  CFT007
     C                   MOVEL     SHOCUS1       PHOCUS1                        CFT007
     C                   MOVEL     SHOCUS2       PHOCUS2                        CFT007
     C                   MOVEL     SHACSV1       PHACSV1                        CFT007
     C                   MOVEL     SHACSV2       PHACSV2                        CFT007
     C                   Endsr                                                  CFT007
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL - Initial subroutine called every time
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     INITIAL       BEGSR
      *
      ** Initialise indicators
     C                   EVAL      *IN15 = *OFF
     C                   EVAL      *IN16 = *OFF
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   SETON                                        98
     C                   ENDIF
      *
     C                   EVAL      SRUNA = AGMRDT
      *
      ** Move workstation ID to screen field.
      *
     C                   EVAL      SWSID = PSJOBNAME
      *
      ** Move module type to screen
      *
     C                   EVAL      SUSER = PSUSER
      *
      ** Move entry parameters to working file fields
      *
     C                   MOVEL     @ACTN         PACTN
     C                   MOVEL     @RftTyp       PPTYP
      *
      ** Test whether message type is incoming or outgoing and display
      ** appropriate header messages
      *
     C                   IF        PPTYP = 'RO'
     C                   EVAL      *IN20 = *ON
     C                   ELSE
     C                   EVAL      *IN20 = *OFF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Main processing subroutine
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     MAIN          BEGSR
      *
      **  Set up subroutine stack name
      *
     C                   ADD       1             q
     C                   MOVEA     'Main'        SrStack(q)
      *                                                                         CFT007
      **  Write error/warning messages to message subfile
      **  and switch on equivalent highlight indicators
      *
      ** Move 'OK' flags into array (to check whether along array for
      ** 'N' flags (field in error)
      *
     C                   MOVEA     OKHdr         @FldErArr
      *
      ** Set screen error indicators according to statue of 'OK' flags
      ** Start screen indicator at first error indicator (i.e IN28)
      *
     C                   Z-ADD     2             Cnt               2 0
     C                   Z-ADD     28            FldEr             2 0
      *
     C                   DOW       Cnt <= NBFIELDS
     C                   IF        @FldErArr(Cnt) = 'N'  OR
     C                             @FldErArr(Cnt) = 'W'
     C                   EVAL      *IN(FldEr) = '1'
     C                   ENDIF
     C                   ADD       1             Cnt
     C                   ADD       1             FldEr
     C                   ENDDO
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      *
      ** Setup screen for diplay, depending on the action code passed
      *
     C                   SELECT
      *
      ** Action is Insert
      *
     C                   WHEN      PActn = 'I'
      *
      ** Turn off field protection indicators
     C                   EVAL      *IN25 = *OFF
      ** Turn off Sender reference protect indicator
     C                   EVAL      *IN26 = *OFF
      ** Enable Refresh key
     C                   EVAL      *IN15 = *OFF
      ** Disable Delete key
     C                   EVAL      *IN16 = *ON
      ** Disable user key
     C                   EVAL      *IN27 = *Off
      *                                                                         CFT007
      ** If BIC DB+ present, enable function keys                               CFT007
      *                                                                         CFT007
     C                   If        CFT007 = 'Y'                                 CFT007
     C                   Eval      *In82 = *On                                  CFT007
     C                   Eval      *In76 = *Off                                 CFT007
     C                   Else                                                   CFT007
     C                   Eval      *In82 = *Off                                 CFT007
     C                   Eval      *In76 = *On                                  CFT007
     C                   Endif                                                  CFT007
      *
      ** Make sure the RFTID is blank for insert
      *
     C                   EVAL      PRFTID = *BLANKS
      *
      ** Action is Amend
      *
     C                   WHEN      PActn = 'A'
      *
      ** Turn off field protection indicators
     C                   EVAL      *IN25 = *OFF
      ** Turn on Senders reference protect indicator
     C                   EVAL      *IN26 = *ON
      ** Enable Refresh key
     C                   EVAL      *IN15 = *OFF
      ** Disable Delete key
     C                   EVAL      *IN16 = *ON
      ** Disable user  key
     C                   EVAL      *IN27 = *Off
      *                                                                         CFT007
      ** If BIC DB+ present, enable function keys                               CFT007
      *                                                                         CFT007
     C                   If        CFT007 = 'Y'                                 CFT007
     C                   Eval      *In82 = *On                                  CFT007
     C                   Eval      *In76 = *Off                                 CFT007
     C                   Else                                                   CFT007
     C                   Eval      *In82 = *Off                                 CFT007
     C                   Eval      *In76 = *On                                  CFT007
     C                   Endif                                                  CFT007
      *
      ** Action is Delete
      *
     C                   WHEN      PActn = 'D'
      *
      ** Turn on field protection indicators
     C                   EVAL      *IN25 = *ON
      ** Turn on Sender reference protect indicator
     C                   EVAL      *IN26 = *ON
      ** Disable Refresh key
     C                   EVAL      *IN15 = *ON
      ** Enable Delete key
     C                   EVAL      *IN16 = *OFF
      ** Disable user  key
     C                   EVAL      *IN27 = *Off
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
      *
      ** Action is Enquire
      *
     C                   WHEN      PActn = 'E'
      *
      ** Turn on field protection indicators
     C                   EVAL      *IN25 = *ON
      ** Turn on Sender reference protect indicator
     C                   EVAL      *IN26 = *ON
      ** Disable Refresh key
     C                   EVAL      *IN15 = *ON
      ** Disable Delete key
     C                   EVAL      *IN16 = *ON
      ** Enable user  key
     C                   EVAL      *IN27 = *On
      *
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
      *
      ** Action is Authorise
      *
     C                   WHEN      PActn = 'X'
      *
      ** Turn on field protection indicators
     C                   EVAL      *IN25 = *ON
      ** Turn on Sender reference protect indicator
     C                   EVAL      *IN26 = *ON
      ** Disable Refresh key
     C                   EVAL      *IN15 = *ON
      ** Conditionally Enable Delete key (for confirm)
     C                   EVAL      *IN16 = *OFF
      ** Disable user  key
     C                   EVAL      *IN27 = *Off
      *
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
      *
     C                   ENDSL
      *
      ** Mapping file fields to screen for display
      *
     C                   MOVEL     PACTN         SACTN
     C                   MOVEL     PRFTID        SRFTID
     C                   MOVEL     PPTYP         SPTYP
     C                   MOVEL     PPYST         SPYST
     C                   MOVEL     PSNDREF       SSNDREF
     C                   MOVEL     PCUSTRF       SCUSTRF
     C                   MOVEL     PBRCA         SBRCA
     C                   MOVEL     PORBR         SORBR
     C                   MOVEL     PBOKC         SBOKC
     C                   MOVEL     PPRFC         SPRFC
     C                   MOVEL     PSWPRIO       SSWPRIO
     C                   MOVEL     PHINPTY       SHINPTY
     C                   MOVEL     PHOCUS1       SHOCUS1
     C                   MOVEL     PHOCUS2       SHOCUS2
     C                   MOVEL     PHOCUS3       SHOCUS3
     C                   MOVEL     PHOCUS4       SHOCUS4
     C                   MOVEL     PHOCUS5       SHOCUS5
     C                   MOVEL     PHACSV1       SHACSV1
     C                   MOVEL     PHACSV2       SHACSV2
     C                   MOVEL     PDBTVDT       SDBTVDT
     C                   MOVEL     PEXDATE       SEXDATE
     C                   MOVEL     PHANDCG       SHANDCG
     C                   MOVEL     PHANDCY       SHANDCY
     C                   MOVEL     PHANDAC       SHANDAC
     C                   MOVEL     PSINST        SSINST
     C                   MOVEL     PAUTHTX       SAUTHTX
     C                   MOVEL     PRFTDST       SRFTDST
     C                   Eval      *IN13 = '0'                                                221761
     C                   If        PRSEQNO <> 0                                               221761
     C                   MOVE      PRSEQNO       SRSEQNO                                      221761
     C                   Eval      *IN13 = '1'                                                221761
     C                   Endif                                                                221761
      *
     C                   MOVEL     PINUSER       SINUSER
     C                   MOVEL     PINDATE       SINDATE
     C                   MOVEL     PINTIME       SINTIME
     C                   MOVEL     PUPDUSR       SUPDUSR
     C                   MOVEL     PUPDDTE       SUPDDTE
     C                   MOVEL     PUPDTIM       SUPDTIM
     C                   MOVEL     PAUP1         SAUP1
     C                   MOVEL     PAUP2         SAUP2
     C                   MOVEL     PRDUAL        SRDUAL
     C                   MOVEL     PAUIN         SAUIN
     C                   MOVEL     PBAUTH        SBAUTH
     C                   MOVEL     PBATUSR       SBATUSR
      *
      *
      ** Mapping file fields to work fields for refresh key but only save
      ** on re-entry to screen
      *
     C                   IF        @MemF ='Y'
     C                   MOVEL     PACTN         WACTN
     C                   MOVEL     PRFTID        WRFTID
     C                   MOVEL     PPTYP         WPTYP
     C                   MOVEL     PPYST         WPYST
     C                   MOVEL     PSNDREF       WSNDREF
     C                   MOVEL     PCUSTRF       WCUSTRF
     C                   MOVEL     PBRCA         WBRCA
     C                   MOVEL     PORBR         WORBR
     C                   MOVEL     PBOKC         WBOKC
     C                   MOVEL     PPRFC         WPRFC
     C                   MOVEL     PSWPRIO       WSWPRIO
     C                   MOVEL     PHINPTY       WHINPTY
     C                   MOVEL     PHOCUS1       WHOCUS1
     C                   MOVEL     PHOCUS2       WHOCUS2
     C                   MOVEL     PHOCUS3       WHOCUS3
     C                   MOVEL     PHOCUS4       WHOCUS4
     C                   MOVEL     PHOCUS5       WHOCUS5
     C                   MOVEL     PHACSV1       WHACSV1
     C                   MOVEL     PHACSV2       WHACSV2
     C                   MOVEL     PDBTVDT       WDBTVDT
     C                   MOVEL     PEXDATE       WEXDATE
     C                   MOVEL     PHANDCG       WHANDCG
     C                   MOVEL     PHANDCY       WHANDCY
     C                   MOVEL     PHANDAC       WHANDAC
     C                   MOVEL     PSINST        WSINST
     C                   MOVEL     PAUTHTX       WAUTHTX
     C                   MOVEL     PRFTDST       WRFTDST
     C                   EVAL      @MemF = 'N'
     C                   ENDIF
      *
      ** Write message subfile, details and footer screen
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     FTM1015DFF
     C                   If        @KeyP = '11'
     C                   EXFMT     FTM1015DD2
     C                   EVAL      *IN27 = *OFF                                 178384
     C                   Else
     C                   EXFMT     FTM1015DD1
     C                   Endif
      *
      ** After EXFMT of screen clear out message proceesing
      ** to enable new messages to be passed from validation module
      *
     C                   EXSR      CLEAR
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
      *
     C                   ENDSR
      *
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * CLEAR - Clear out all error processing
      *
      * CALLED FROM: - SR/MAIN
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     CLEAR         BEGSR
      *
      ** Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      ** Set Screen Error Indicators off
      *
     C                   MOVEA     @IndOff       *IN(28)
      *
      ** Clear error fields
      *
     C                   MOVE      *ALL'Y'       OkHdr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      Idx = 0
      *
      ** Clear warning fields
      *
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      WIdx = 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      *
      ** Return code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    @Actn             1
      ** Rft type
     C                   PARM                    @RftTyp           2
      ** Swift Reference
     C                   PARM                    @SwiftRf         28
      ** Details RFT (in screen format)
     C                   PARM                    Ft101hs
      ** Fields flagged in Error
     C                   PARM                    OKHdr
      *
      ** OUTPUT PARAMETERS
      *
      ** Screen to be displayed
     C                   PARM                    @KeyP
      ** Screen last displayed
     C                   PARM                    @MemF
      ** ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      *                                                                         CFT007
      * Field Name                                                              CFT007
     C                   PARM                    CsrFld                         CFT007
      * Status description                                                      188649
     C                   PARM                    SAIND                          188649
      *
      ** END OF PARAMETERS DECLARATION
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'FTM1015DP'
      *
      ** Check if iban is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*VERIFY'     @Optn             7
     C                   PARM      'CFT004'      @Sard             6
     C                   PARM                    Dsfdy
      *
     C                   IF        @Rtcd = *BLANKS
     C                   MOVE      'Y'           CFT004            1
     C                   ELSE
     C                   IF        @Rtcd = '*NRF'
     C                   MOVE      'N'           CFT004
     C                   ELSE
      *
      ** Database Error
      *
     C                   EVAL      Dbfile = 'SCSARDPD'                          ************
     C                   EVAL      DBase = 017                                  * DBERR 904*
     C                   EVAL      Dbkey = @Optn                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Save fields on entry to screen
      *
     C                   EVAL      @MemF = 'Y'
      *
      ** Initialise indicators
      *
     C                   EVAL      *IN15 = *OFF
     C                   EVAL      *IN16 = *OFF
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
      *
     C                   MOVEL     @ACTN         PACTN
     C                   MOVEL     @RftTyp       PPTYP
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   EVAL      MODULEID = 'FT'
     C                   EVAL      #MSGFILE = 'FTUSRMSG'
     C                   MOVEL     '*'           ##PGM
      *                                                                         CFT007
      ** Access SAR details file to determine if CFT007                         CFT007
      ** (BIC Database +) is active                                             CFT007
      *                                                                         CFT007
     C                   CALLB     'AOSARDR0'                                   CFT007
     C                   PARM      *BLANKS       @Rtcd                          CFT007
     C                   PARM      '*VERIFY'     @Optn                          CFT007
     C                   PARM      'CFT007'      @Sard             6            CFT007
     C     SCSARD        PARM      SCSARD        Dsfdy                          CFT007
      *                                                                         CFT007
      ** Database Error                                                         CFT007
      *                                                                         CFT007
     C                   IF        @Rtcd <> *BLANKS AND                         CFT007
     C                             @Rtcd <> '*NRF'                              CFT007
     C                   EVAL      DBFILE = 'SCSARDPD'                          CFT007
     C                   EVAL      DBASE = 999                                  CFT007
     C                   EVAL      DBKEY = 'CFT007'                             CFT007
     C                   EXSR      *PSSR                                        CFT007
     C                   ENDIF                                                  CFT007
      *                                                                         CFT007
     C                   IF        @Rtcd = *BLANKS                              CFT007
     C                   MOVEL     'Y'           CFT007            1            CFT007
     C                   ELSE                                                   CFT007
     C                   MOVEL     'N'           CFT007                         CFT007
     C                   ENDIF                                                  CFT007
      *                                                                                     MD022652
      ** Access SAR details file to determine if CFT050                                     MD022652
      ** SWIFTRef Directories Upload is active                                              MD022652
      *                                                                                     MD022652
     C                   CALLB     'AOSARDR0'                                               MD022652
     C                   PARM      *BLANKS       PRtcd             7                        MD022652
     C                   PARM      '*VERIFY'     POptn             7                        MD022652
     C                   PARM      'CFT050'      PSard             6                        MD022652
     C     SCSARD        PARM      SCSARD        Dsfdy                                      MD022652
      *                                                                                     MD022652
      ** Database Error                                                                     MD022652
      *                                                                                     MD022652
     C                   IF        PRtcd <> *BLANKS AND                                     MD022652
     C                             PRtcd <> '*NRF'                                          MD022652
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD022652
     C                   EVAL      DBASE = 999                                              MD022652
     C                   EVAL      DBKEY = 'CFT050'                                         MD022652
     C                   EXSR      *PSSR                                                    MD022652
     C                   ENDIF                                                              MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
     C                   IF        PRtcd = *BLANKS                                          MD022652
     C                   EVAL      CFT007 = 'Y'                                             MD022652
     C                   ENDIF                                                              MD022652
                                                                                            MD022652
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY FTCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @IndOff
000000000000000000000000000000
