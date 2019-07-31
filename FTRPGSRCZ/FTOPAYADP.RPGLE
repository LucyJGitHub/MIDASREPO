     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Cover Message display')     *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAYADP - Outgoing Payments Cover Message Display 1        *
      *                                                               *
      *  Function:  This API module will serve as the screen display/ *
      *             input module of Cover Message display 1           *
      *                                                               *
      *  Called By: FTOPAY1SN                                         *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD035776           Date 10Sep15               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035776 - User need to press twice on input screen          *
      *           - Remove unsupported keywords of HATS from dspf     *
      *             (Recompile)                                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPAYADF CF   E             WORKSTN INFDS(INFDS#)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     12-41 Field Error - highlight, reverse image and position *
      *           cursor fields                                       *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
      * Miscellaneous Charge descriptions
     D @EI             S              1    DIM(60)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D FTVOPAY       E DS                  EXTNAME(FTVOPAYPD)
      ** Screen fields (Initial Screen)
     D FTOPAY1       E DS                  EXTNAME(FTOPY1PD)
      ** Screen fields (Initial Screen)
 
     D FTOPAYA       E DS                  EXTNAME(FTOPYAPD)
      ** Payment Cover Message display file layout 1
 
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)
      ** Error Indicators (Cover Message screen 1)
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D  FuncText       DS            56
     D  F3F12text              1     19
     D  F4text                20     29
     D  F16text               30     40
     D  F19text               41     56
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D #MSDTA          S            132
     D #MSTX1          S            132
     D #MSTX2          S            512
 
     D DDSTS           S             24A
     D @EKYFD          S              1A
     D @EDTFD          S              1A
     D @EINKD          S              1A
     D @INKC           S              1A
     D @INKD           S              1A
     D @INKL           S              1A
     D @INKE           S              1A
     D CursorLoc       S              5S 0
 
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
 
      ** Main processing
 
     C                   ExSr      SrMain
 
      ** Command F3 pressed, exit
 
     C                   If        @INKC = *On
     C                   Eval      *INLR = *On
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrMain
      *****************************************************************
      *                                                               *
      * SR/SrMain    - Main processing                                *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrMain        BegSr
 
      ** Move 'OK' flags into array for checking
 
     C                   MoveA     FTEOPYA       @EI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-Add     1             C                 2 0
     C                   Z-Add     12            E                 2 0
 
     C                   DoU       C > 60
     C                   If        (@EI(C) = 'N') Or (@EI(C) = 'W')
     C                   Eval      *IN(E) = *On
     C                   EndIf
     C                   Eval      C = C + 1
     C                   Eval      E = E + 1
     C                   Enddo
 
      ** Set up the payment reference to be used by the message handler
 
     C                   Eval      TranRef = SPREF
     C                   Eval      ActionCode = SACTION
 
     C                   Eval      *IN71 = *On
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
      ** Position cursor on action code if it is blank
 
     C     SAction       Comp      *BLANK                                 68
 
      ** Enable detail fields (all fields except action code & payment
      ** Reference
 
     C     @EDTFD        Comp      'Y'                                7070
 
      ** Set up function key footer text
 
     C                   Eval      SCCMDTXT = *Blanks
     C                   Eval      %SUBST(SCCMDTXT:1:19) = F3F12text
     C                   If        @EINKD = 'Y'
     C                   Eval      %SUBST(SCCMDTXT:60:9) = F4text
     C                   Endif
 
      ** Default output fields
 
      ** Write message subfile, details and footer screen
 
     C                   Time                    DDTime
 
     C                   Write     FTOPAYAS0
     C                   Write     FTOPAYAD1
     C                   Write     FTOPAYAF1
 
      ** Read details screen
 
     C                   If        WriteOnly <> 'Y'
     C                   Read      FTOPAYAD1                              01
     C                   EndIf
      *
 
      ** Clear message subfile
 
     C                   Call      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   MoveA     @Z0           *IN(10)
 
      ** Set return keys
 
     C                   Eval      @INKC = *INKC
     C                   Eval      @INKD = *INKD
     C                   Eval      @INKL = *INKL
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Initial Processing                            *
      *                                                               *
      * Called By: Automatically executed when program starts         *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Receive input parameters
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    FTOPAY1
     C                   Parm                    FTVOPAY
     C                   Parm                    FTOPAYA
     C                   Parm                    DDSTS
     C                   Parm                    FTEOPYA
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    @EKYFD
     C                   Parm                    @EDTFD
     C                   Parm                    @EINKD
     C                   Parm                    @INKC
     C                   Parm                    @INKD
     C                   Parm                    @INKL
     C                   Parm                    @INKE
     C                   Parm                    WriteOnly
     C                   Parm      @#RWCL        CursorLoc
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDBANKPD'    DBFILE
     C                   Z-Add     1             DBASE
     C                   MoveL     @Optn         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Retrieve the text for footer function keys using MEC1150
 
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTM2618'     #MSGID
     C                   Parm      'FTUSRMSG'    #MsgFile
     C                   Parm                    #MSDTA
     C                   Parm      *Blanks       #MSTX1
     C                   Parm      *Blanks       #MSTX2
 
     C                   Movel     #MSTX1        FuncText
 
      ** Message subfile control
 
     C                   Move      True          *IN97
     C                   Movel     '*'           DDPGMQ
 
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for FT *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY FTCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
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
(c) Finastra International Limited 2009
**  @Z0
000000000000000000000000000000000000000000000000000000000000
