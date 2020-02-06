     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Hold Mail')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Service fees Validation       *
      *                                                               *
      *  SDVHMIN - Validate Hold Mail                                 *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Service Fees amendments must not be                 *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Define work field SAR SO1423
     D  WUKKST         S              1    Inz(*Blanks)
      ** Define work field Access Pgm Return Code
     D  WUAPRC         S              7    Inz(*Blanks)
      ** Define work field Access obj dummy DS (76)
     D  WUFDY          S             76    Inz(*Blanks)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Work Variables
     D DDHMIN          S              1A
     D DDHMINOK        S              1A
     D WUSARN          S              5A
     D WQ0010          S              7A
     D WQ0011          S              7A
     D WQ0012          S              6A
     D WQ0013          S             76A
 
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
     C                   Z-ADD     0             WIdx
 
      ** Validation
 
      ** Hold Mail
      ** Hold Mail is Blank
     C     DDHMIN        IFEQ      *BLANK
      ** Customer Service Fees on is Present
     C     WUKKST        IFEQ      'Y'
     C                   EVAL      DDHMINOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDHMIN   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1974'
     C                   END
 
     C                   ELSE
      ** Hold Mail is invalid value
     C                   IF        (DDHMIN <> 'N' AND DDHMIN <> 'Y')
     C                   EVAL      DDHMINOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDHMIN   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1975'
     C                   END
     C                   END
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Field(s) requiring validation
     C                   PARM                    DDHMIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Group 2-      OK
     C                   PARM                    DDHMINOK
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Customer Service Fees
     C                   MOVEL     'SO1423'      WUSARN
      ** SAR switched on check - Standard Functions
     C                   CALL      'AOSARDR0'                           90
     C     WUAPRC        PARM      WUAPRC        WQ0010
     C                   PARM      '*VERIFY'     WQ0011
     C     WUSARN        PARM      WUSARN        WQ0012
     C                   PARM      WUFDY         WQ0013
 
     C     *IN90         IFEQ      '1'
 
      ** Call to program ended in error
     C                   EVAL      DBKEY  = 'AOSARDR0'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBASE  =  001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     WUAPRC        IFEQ      '*EMPTY'
     C     WUAPRC        OREQ      '*EOF'
     C     WUAPRC        OREQ      '*ERROR'
     C     WUAPRC        OREQ      '*CLOSE'
     C     WUAPRC        OREQ      '*OPEN'
     C     WUAPRC        OREQ      '*NRF'
     C                   MOVEL     'N'           WUKKST
     C                   ELSE
     C                   MOVEL     'Y'           WUKKST
     C                   END
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
