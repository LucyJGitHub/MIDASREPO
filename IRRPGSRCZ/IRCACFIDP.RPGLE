     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Collars/Floors Initial Screen')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCACFIDP - Caps/Collars/Floors Initial Screen Display       *
      *                                                               *
      *  Function:  This module will process the Caps/Collars/Floors  *
      *             initial screen details.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Caps/Collars/Floors Initial Screen Display File
     FIRCACFIDF CF   E             WORKSTN INFSR(*PSSR)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *     10-60 Field Error - highlight screen fields               *
      *       71  Enable Function Key - F5                            *
      *       72  Enable Function Key - F7 and F8                     *
      *       73  Enable Function Key - F12                           *
      *       74  Enable Function Key - F15                           *
      *       99  Read error                                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
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
 
     D WEI             S              1    DIM(60)
     D WZ0             S              1    DIM(60) CTDATA PERRCD(60)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
     D Cx              S              2P 0
     D Ex              S              2P 0
 
      ** Function keys to activate
     D PEINKE          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
 
      ** Function keys activated
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** Error indicators
     D OKDLNO          S              1A
     D OKACCD          S              1A
     D OKDTYP          S              1A
 
     D BJMRDT          S              7A
     D IRECACF         S              3A
     D PSucDlNo        S              6A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main Processing
 
     C                   EXSR      SRProcess
 
      ** Return
 
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process Details                                  *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C                   IF        PSucDlNo <> *BLANK
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1) = 'MMM3011'
     C                   EVAL      MsgDtaArr(1) = PSucDlNo
     C                   EVAL      PSucDlNo = *BLANK
     C                   ENDIF
 
      ** Move 'OK' Flags into array for checking
 
 
     C                   EVAL      IRECACF = *BLANKS
     C                   EVAL      IRECACF = OKACCD + OKDLNO + OKDTYP
     C                   MOVEA     IRECACF       WEI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             Cx
     C                   Z-ADD     10            Ex
 
     C                   DOU       Cx > 60
 
     C                   IF        WEI(Cx) = 'N' OR WEI(Cx) = 'W'
     C                   EVAL      *IN(Ex) = *ON
     C                   ENDIF
 
     C                   EVAL      Cx = Cx + 1
     C                   EVAL      Ex = Ex + 1
     C                   ENDDO
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
 
      ** Position cursor on Action code if it is blank
 
     C                   IF        #0ACCD = *BLANK
     C                   EVAL      *IN68 = *ON
     C                   ELSE
     C                   EVAL      *IN68 = *OFF
     C                   ENDIF
 
      ** Enable CF05 (Refresh)
 
     C                   IF        PEINKE = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF
 
      ** Enable CF07 (Read Next), CF08 (Previous Record)
 
     C                   IF        PEINKG = 'Y' OR PEINKH = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
     C                   ENDIF
 
      ** Enable CF12 (Cancel)
 
     C                   IF        PEINKL = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ELSE
     C                   EVAL      *IN73 = *OFF
     C                   ENDIF
 
      ** Enable CF15 (Browse screen).
 
     C                   IF        PEINKP = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ELSE
     C                   EVAL      *IN74 = *OFF
     C                   ENDIF
 
      ** Write message subfile, details and footer screens.
 
     C                   TIME                    #0TIME
     C                   WRITE     IRCACFIC0
     C                   WRITE     IRCACFIF0
     C                   WRITE     IRCACFIF1
 
     C                   READ      IRCACFIF1                              99
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off.
 
     C                   MOVEA     WZ0           *IN(10)
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKE = *INKE
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKP = *INKP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters :
 
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Action code
      ** Deal Number
      ** Deal Type
      ** Successful Insert Message
 
     C                   PARM                    #0DLNO
     C                   PARM                    #0ACCD
     C                   PARM                    #0DTYP
     C                   PARM                    PSucDlNo
 
      ** Enable function keys
      ** KE = Command key 05 = Refresh
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KL = Command key 12 = Cancel
      ** KP = Command key 15 = Browse
 
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
 
      ** OK Action code
      ** OK Deal Number
      ** OK Deal Type
 
     C                   PARM                    OKDLNO
     C                   PARM                    OKACCD
     C                   PARM                    OKDTYP
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** WARNING
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Standing Data - System Run Date
 
     C                   PARM                    BJMRDT
 
      ** Output Parameters :
 
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KE = Command key 05 = Refresh
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KL = Command key 12 = Cancel
      ** KP = Command key 15 = Browse
 
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Set Message File
 
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Set user and job details
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
 
      ** Message subfile control and program queue initialisation.
 
     C                   EVAL      *IN97 = *ON
     C                   EVAL      #0PGMQ = '*'
 
      ** Initialise the fixed parameters for ZAMSGHNDLE.
 
     C                   EVAL      ModuleID     = 'IR'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
 
      ** Program, module and procedure names for database error processing
      ** The following /COPY sets these values.
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
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
      *
**  CPY@
(c) Finastra International Limited 2002
** @Z0
000000000000000000000000000000000000000000000000000000000000
