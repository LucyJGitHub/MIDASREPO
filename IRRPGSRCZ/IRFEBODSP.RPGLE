     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Fees/Buy-Outs display')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRFEBODSP - Fees/Buy-Outs/Processing Method/Next Principal   *
      *              Change Date Details Display                      *
      *                                                               *
      *  Function:  This module will allow the Fees/Buy-Outs/ etc     *
      *             screen to de displayed.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CDL038             Date 10May05               *
      *  Prev Amend No. CAP041  *CREATE    Date 18Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
      /EJECT
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FIRFEBODF  CF   E             WORKSTN
 
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Array of IRS fields status
     D @EI             S              1    DIM(60)
 
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
 
      ** Transaction Details in screen format
     D NwFBScnFld    E DS                  EXTNAME(IRFEB1PD)
 
      ** Swichable features details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for access programs. short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access progrmas, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D/COPY QWINDSRC,IRSIRSGDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** F3 Exit
      ** F8 Next screen
      ** F12 Cancel
     D @INKC           S              1A
     D @INKH           S              1A
     D @INKL           S              1A
 
      ** Enable detail fields
     D @EDTFLD         S              1A
 
     D E               S              2  0
     D C               S              2  0
 
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
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
      ** Process Errors and Warning Messages
      *
     C                   EXSR      SRProcErr
      *
      ** Initialize variables
      *
     C                   MOVEA     '000000'      *IN(24)
     C                   MOVEA     '0000000'     *IN(32)
     C                   EVAL      *IN83 = *OFF
      *
      ** Allow F8 Next Screen if in Enquire mode
      *
     C                   IF        #1ACTN = 'E'
     C                   EVAL      *IN24 = *ON
     C                   ENDIF
      *
      ** Display unsettled interest and interest adjustment.
      *
     C                   IF        (CIR002 = 'Y' OR CIR006 = 'Y')
     C                             AND (#1ACTN = 'E' OR #1ACTN = 'A'
     C                             OR #1ACTN = 'R')
 
     C                   EVAL      *IN32 = *ON
      *
      ** Our unsettled interest
     C                   IF        CIR006 = 'N' OR SOIPM = 'A'
     C                             OR SOIPM = 'I' OR SOIPM = 'L'
     C                   EVAL      *IN37 = *ON
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
      *
      ** Their unsettled interest
     C                   IF        CIR006 = 'N' OR STIPM = 'A'
     C                             OR STIPM = 'I' OR STIPM = 'L'
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN34 = *ON
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Protect Up-Front Fee details
      *
     C                   IF        #1ACTN = 'A' AND AGRDNB > #1UPVD AND
     C                             #1UPVD <> *ZERO OR
     C                             #1ACTN = 'E' OR
     C                             #1ACTN = 'R'
     C                   EVAL      *IN26 = *ON
     C                   ENDIF
      *
      ** Protect Buy-out details
      *
     C                   IF        #1ACTN = 'A' AND AGRDNB > #1BODD AND
     C                             #1BODD <> *ZERO OR
     C                             #1ACTN = 'E' OR
     C                             #1ACTN = 'R'
     C                   EVAL      *IN27 = *ON
     C                   ENDIF
      *
      ** Buy-out details can only be entered if value
      ** date of the deal has passed
      ** Buy-outs will not be available for OIS Deals.
      *
 
     C                   IF        #1ACTN = 'I' OR #1ACTN = 'A'
     C                   IF        #1VDAT > AGRDNB OR
     C                             #1UICF = 'O' AND CIR007 = 'Y' OR
     C                             #1TICF = 'O' AND CIR007 = 'Y'
     C                   EVAL      *IN27 = *ON
     C                   ENDIF
     C                   ENDIF
      *
      ** Protect Up-Front Fee and Buy-Out details
      ** Protect Next Principal Change Date and
      ** Processing Method
      *
     C                   IF        CIR001 <> 'Y' OR
     C                             #1ACTN = 'E'  OR
     C                             #1ACTN = 'R'  OR
     C                             #1ACTN = 'X' OR
     C                             @EDTFLD = 'N'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN29 = *ON
     C                   ENDIF
      *
      ** Interest processing method is not amendable.
      *
     C                   IF        #1ACTN <> 'I'
     C                   EVAL      *IN25 = *ON
     C                   ENDIF
      *
     C                   WRITE     #MSGCTL
      *
      ** Single currency
     C                   IF        #1DTYP = 'RS'
     C                   EXFMT     IRFEBOD1
     C                   ENDIF
      *
      ** Cross currency
     C                   IF        #1DTYP = 'RX'
     C                   EXFMT     IRFEBOD2
     C                   ENDIF
      *
      ** Caps, collars and floors
     C                   IF        CIR006 = 'Y' AND
     C                             (#1DTYP = 'RP' OR
     C                             #1DTYP = 'RR' OR
     C                             #1DTYP = 'RF')
 
     C                   SELECT
     C                   WHEN      #1DTYP = 'RP'
     C                   EVAL      SNARR = 'INTEREST  RATE   CAP'
 
     C                   WHEN      #1DTYP = 'RR'
     C                   EVAL      SNARR = 'INTEREST RATE COLLAR'
 
     C                   WHEN      #1DTYP = 'RF'
     C                   EVAL      SNARR = 'INTEREST RATE  FLOOR'
 
     C                   ENDSL
 
     C                   EXFMT     IRFEBOD3
     C                   ENDIF
 
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKH = *INKH
     C                   EVAL      @INKL = *INKL
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcErr - Process Errors and Warnings                      *
      *                                                               *
      *****************************************************************
 
     C     SRProcErr     BEGSR
 
     C                   Z-ADD     1             C
      *
      ** Process all error messages
      *
     C                   DOW       MsgIdArr(C) <> *Blanks
     C                   MOVEL     *Blanks       ZAMSID
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID           10
     C                   ADD       1             C
     C                   ENDDO
 
     C                   Z-ADD     1             C
      *
      ** Process all warning messages
      *
     C                   DOW       WMsgIdArr(C) <> *Blanks
     C                   MOVEL     *Blanks       ZAMSID
     C                   MOVEL     WMsgIdArr(C)  ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID           10
     C                   ADD       1             C
     C                   ENDDO
      *
      ** Seton all indicators for invalid screen fields.
      *
     C                   EVAL      C = 1
     C                   EVAL      E = 40
     C                   MOVEA     OKFEBO        @EI
 
     C                   DOU        C > 10
 
     C                   IF         @EI(C) <> 'Y'
     C                   MOVEL     '1'           *IN(E)
     C                   ELSE
     C                   MOVEL     '0'           *IN(E)
     C                   ENDIF
 
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details in screen format
     C                   PARM                    NwFBScnFmt
      *
      ** Transaction Details in screen format - other fields
     C                   PARM                    NwFBScnFld
      *
      ** OUTPUTS
      ** =======
     C                   PARM                    OKFEBO
      *
      ** Error messages
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning messages
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enable details fields
     C                   PARM                    @EDTFLD
      *
      ** Enabled Function keys
     C                   PARM                    @INKC
     C                   PARM                    @INKH
     C                   PARM                    @INKL
      *
      ** Deal info passed from calling programs
     C                   PARM                    DATA
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C                   MOVEL     PSJobName     SWSID
     C                   MOVEL     '*'           ##PGM
      *
      ** Check if Multi-branch
      *
     C                   EVAL      *IN83 = *OFF
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN83 = *ON
     C                   ENDIF
      *
      **  Access SAR details file to determine if CIR001 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'CIR001'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR001            1
     C                   ELSE
     C                   MOVEL     'N'           CIR001
     C                   ENDIF
      *
      **  Access SAR details file to determine if CIR002 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     'CIR002'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR002            1
     C                   ELSE
     C                   MOVEL     'N'           CIR002
     C                   ENDIF
      *
      **  Access SAR details file to determine if CIR006 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR006'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     'CIR006'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR006            1
     C                   ELSE
     C                   MOVEL     'N'           CIR006
     C                   ENDIF
      *
      **  Access SAR details file to determine if CIR007 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR007'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     'CIR007'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR007            1
     C                   ELSE
     C                   MOVEL     'N'           CIR007
     C                   ENDIF
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
