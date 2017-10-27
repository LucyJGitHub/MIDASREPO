     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Val deal date, value date, option date')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVSPVDT - Split Value Date Validation Module                *
      *                                                               *
      *  Function: This module will validate the screen entered       *
      *            split value date                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2017            *
      *                                                               *
      *  Last Amend No. CDL099  *CREATE    Date 06Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date                                    *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the FX standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      * System values fields
     D PRtCd           S              7A
     D PSysVal01       S             20A   INZ('FXDealSplitValueDays')
     D PCurSet01       S            200A
     D PSysVal02       S             20A
     D PCurSet02       S            200A
     D PSysVal03       S             20A
     D PCurSet03       S            200A
     D PSysVal04       S             20A
     D PCurSet04       S            200A
     D PSysVal05       S             20A
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A
     D WSysVal01       S              2S 0
     D #Diff5          S              5S 0
     D #Diff3          S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
     C                   MOVE      'Y'           OK#SVDT
      *
      ** VDATV - Value Date Validation
     C                   if        DDSDAT <> *BLANKS
     C                   EXSR      VDATV
     C                   endIF
      *
      ** If an error was found, set the return code appropriately
     C     OK#SVDT       IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VDATV - VALUE DATE VALIDATION                                 *
      *****************************************************************
     C     VDATV         BEGSR
      *
      ** If value date is numeric, convert it to a day number
     C                   TESTN                   DDSDAT               9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDSDAT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    ValuDtDN          5 0
     C                   ENDIF
      *
      ** Error if value date is not numeric or is an invalid date
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C     RetCodeOut    OREQ      'Error'
     C                   MOVE      'N'           OK#SVDT
     C                   ADD       1             Idx
     C                   MOVEL     'DDSDAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0125'     MsgIdXAr(Idx)
     C                   MOVE      *BLANKS       MsgDtaXAr(Idx)
     C     BJDFIN        IFEQ      'D'
     C                   MOVEL     'DDMMYY'      MsgDtaXAr(Idx)
     C                   ELSE
     C                   MOVEL     'MMDDYY'      MsgDtaXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** Convert DDVDAT also to a day number
     C                   TESTN                   DDVDAT               9695
     C     *IN95         IFEQ      '1'
     C     *IN96         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDVDAT        @@DATE
     C                   PARM                    BJDFIN
     C                   PARM                    DDVDATNo          5 0
     C                   ENDIF
      *
      ** Error if value date is not numeric or is an invalid date
     C     *IN95         IFEQ      '0'
     C     *IN96         ANDEQ     '0'
     C     RetCodeOut    OREQ      'Error'
     C                   MOVE      'N'           OK#SVDT
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0125'     MsgIdXAr(Idx)
     C                   MOVE      *BLANKS       MsgDtaXAr(Idx)
     C     BJDFIN        IFEQ      'D'
     C                   MOVEL     'DDMMYY'      MsgDtaXAr(Idx)
     C                   ELSE
     C                   MOVEL     'MMDDYY'      MsgDtaXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** Access SplitValue system value
     C                   CALLB     'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10
 
     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     PCurSet01     WSysVal01
      *
      ** Get the difference between DDSDAT and DDVDAT
     C                   EVAL      #Diff5 = ValuDtDN - DDVDATNo
 
     C                   if        #Diff5 < 0
     C                   EVAL      #Diff5 = %abs(#Diff5)
     C                   endIF
 
     C                   MOVE      #Diff5        #Diff3
      *
      ** If difference between DDSDAT and DDVDAT is greater than the
      ** current setting
      *
     C                   IF        #Diff3 > WsysVal01
     C                   MOVE      'N'           OK#SVDT
     C                   ADD       1             Idx
     C                   MOVEL     'SVSVDT'      FldNamXAr(Idx)
     C                   MOVEL     'DLF0045'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** If no record found in SDSVALPD
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C                   MOVE      'N'           OK#SVDT
     C                   ADD       1             Idx
     C                   MOVEL     'PSysVal01'   FldNamXAr(Idx)
     C                   MOVEL     'DLF0047'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If valid, do holiday validation
     C     OK#SVDT       IFNE      'N'
     C                   CALLB     'ZCHKH'
     C                   PARM      ValuDtDN      ZDAYNO            5 0
     C                   PARM      DDSCCY        ZCCY              3
     C                   PARM      *BLANK        ZLOC              3
     C                   PARM      *BLANK        ZIND              1
     C     ZIND          IFEQ      'H'
     C                   MOVE      'N'           OK#SVDT
     C                   ADD       1             Idx
     C                   MOVEL     'SVSVDT'      FldNamXAr(Idx)
     C                   MOVEL     'DLF0046'     MsgIdXAr(Idx)
     C                   MOVE      *BLANKS       MsgDtaXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If valid, output value date
     C     OK#SVDT       IFNE      'N'
     C                   EVAL      SVSVDT = DDSDAT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    DDSDAT            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDSCCY            3
     C                   PARM                    BJDFIN            1
      *
      ** OUTPUTS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    OK#SVDT           1
     C                   PARM                    SVSVDT            6
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2017
