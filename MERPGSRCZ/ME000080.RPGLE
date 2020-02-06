     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Incoming MT920 Enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - SWIFT Direct Link Module                             *
      *                                                               *
      *  ME000080 - Incoming MT920 Enquiry                            *
      *                                                               *
      *  Function: This module displays the Incoming MT920.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL013 *CREATE     Date 10Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         SFLCLR indicator                                *
      *    02         SFLDSP indicator                                *
      *    03         SFLDSPCTL indicator                             *
      *    04         Rollup indicator                                *
      *    05         Subfile Change indicator                        *
      *    06         Show 'Enquire' and 'Rollup/Rolldown' in screen  *
      *    07         End of File MEI920L0                            *
      *    08         End of File MEP920L0                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBldSubf    - Build subfile record                          *
      *  SRFmtScrFlds - Format screen fields                          *
      *  SRDspScrn    - Display records on screen                     *
      *  SRChkActn    - Check action made after display of screen     *
      *  SRChkIn      - Check input fields                            *
      *  SRChkRec     - Check record if the same with selection       *
      *  SREnquire    - Process enquiry on records                    *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas ME Incoming MT920 Audit File
     FMEI920L0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ME Incoming MT920 Parts
     FMEP920L0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Browse screen
     FME000080DFCF   E             WORKSTN
     F                                     SFILE(ME000080S0:WRRN)
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,STD_D_SPEC
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
 
     D Up              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D Lo              C                   'abcdefghijklmnopqrstuvwxyz'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D MONTHS          S              3    DIM(12) CTDATA PERRCD(12)
     D WArTrn          S             16    DIM(400)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSTOPA          DS
     D  WCBRC                  1      3
     D  WDAS1                  4      4
     D  WCCUS                  5     10
     D  WDAS2                 11     11
     D  WCCCY                 12     14
     D  WDAS3                 15     15
     D  WCACD                 16     19
     D  WDAS4                 20     20
     D  WCASN                 21     22
 
     D DSINPUT         DS
     D  WPIMIR                 1     28
     D  WPDATE                29     34
     D  WPTIME                35     42
     D**WPMSGT*******         43     45
     D**WPOTRN*******         46     61
 
     D DSTIME          DS
     D  WHour                  1      2
     D  WColon1                3      3
     D  WMin                   4      5
     D  WColon2                6      6
     D  WSec                   7      8
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Parameters for ZSEDIT
     D PINAMT          S             15  0
     D PDECPL          S              1  0
     D PCODE           S              1A
     D POUTAMT         S             21A
 
      ** Parameters for MEC0600
     D PTRNO           S             16A
     D PCFMT           S              1A
     D PACTN           S              1A
     D PFILA           S              1A
     D PRCODE          S              2A
     D PERROR          S              1A
 
      ** Other fields used
     D WRrn            S              5P 0
     D WCnt            S              3  0
     D WRecOk          S              1A
     D WSIMIR          S              1A
     D WSDATE          S              1A
     D WSTIME          S              1A
     D WSMSGT          S              1A
     D WSOTRN          S              1A
     D WPInput         S             42A
     D WX1             S              3  0
     D WX2             S              3  0
     D WTime           S              6A
     D WOTime          S              8A
     D W1OTRN          S             16A
     D W0OTRN          S             16A
     D WDate           S              6A
     D WYear           S              2A
     D WMon            S              2A
     D WDay            S              2A
     D WMonth          S              3A
     D WMDate          S              7A
     D WLast           S              1A
     D X               S              2  0
     D Pos             S              5U 0
     D WWRCVT          S              4A
     D KeyIMIR         S                   LIKE(MPIMIR)                         Incoming MIR
     D KeyMSGR         S                   LIKE(MPMSGR)                         Message Requested
     D KeyACTR         S                   LIKE(MPACTR)                         Account Requested
     D SaveIMIR        S                   LIKE(MPIMIR)                         Incoming MIR
     D SaveMSGR        S                   LIKE(MPMSGR)                         Message Requested
     D SaveACTR        S                   LIKE(MPACTR)                         Account Requested
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Build record subfile
 
     C                   EXSR      SRBldSubf
 
      ** Display records on screen
 
     C                   EXSR      SRDspScrn
 
      ** End program when F3 is pressed
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSubf - Build record subfile                             *
      *                                                               *
      *  Called by: Main Processing, SRChkActn                        *
      *                                                               *
      *  Calls: SRFmtScrFlds, SRChkRec                                *
      *                                                               *
      *****************************************************************
     C     SRBldSubf     BEGSR
 
      ** Initialise subfile relative record number
 
     C                   EVAL      WRrn  = *ZERO
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active
 
     C                   EVAL      *IN01 = *ON
     C                   WRITE     ME000080C0
     C                   EVAL      *IN01 = *OFF
 
      ** Save key fields
 
     C                   EVAL      SaveIMIR = *BLANKS
     C                   EVAL      SaveMSGR = *BLANKS
     C                   EVAL      SaveACTR = *BLANKS
 
      ** Read record
 
     C     #1IMIR        SETLL     MEI920L0
     C                   READ      MEI920L0                               07
 
      ** Enable SFLDSP and seton ROLLUP indicator to drive intial loop
 
     C                   EVAL      *IN02 = *ON
     C                   EVAL      *IN04 = *ON
 
      ** Loop 1: Read records from the file until end of file or
      **         ROLLUP has not been entered
 
     C                   DOW       NOT %EOF(MEI920L0) AND
     C                             *IN04 = *ON
 
 
      ** Initialise/Reset count of records written to subfile page
 
     C                   EVAL      WCnt = *ZERO
 
      ** Loop 2: Write each record read to subfile until end of file
      **         or subfile page is full
 
     C                   DOW       NOT %EOF(MEI920L0) AND
     C                             WCnt < 4
 
      ** Loop 3: Write each record read from MEP920PD
 
     C                   EVAL      KeyIMIR = MIIMIR
     C     KMEP          SETLL     MEP920L0
 
     C                   IF        MIIMIR = SaveIMIR
     C                   EVAL      KeyMSGR = SaveMSGR
     C                   EVAL      KeyACTR = SaveACTR
     C     KMEP          SETGT     MEP920L0
     C                   ENDIF
 
     C                   READ      MEP920L0                               08
 
     C                   DOW       NOT %EOF(MEP920L0) AND
     C                             WCnt < 4 AND MIIMIR = MPIMIR
 
      ** Save key fields
 
     C                   EVAL      SaveIMIR = MPIMIR
     C                   EVAL      SaveMSGR = MPMSGR
     C                   EVAL      SaveACTR = MPACTR
 
      ** Format screen fields for display
 
     C                   EXSR      SRFmtScrFlds
 
     C                   EXSR      SRChkRec
 
     C                   IF        WRecOk = 'Y'
 
      ** Increment the subfile record no. and records written fields
 
     C                   ADD       1             WRrn
     C                   ADD       1             WCnt
 
      ** Write the record to subfile
 
     C                   WRITE     ME000080S0
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      MEP920L0                               08
 
      ** End of Loop 3
 
     C                   ENDDO
 
      ** Read next record
 
     C                   IF        %EOF(MEP920L0) OR MIIMIR <> MPIMIR
     C                             OR WCNT < 4
     C                   READ      MEI920L0                               07
     C                   ENDIF
 
      ** End of Loop 2
 
     C                   ENDDO
 
      ** End of Loop 1
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtScrFlds - Format screen fields for output               *
      *                                                               *
      *  Called by: SRBldSubf                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRFmtScrFlds  BEGSR
 
      ** Write details to corresponding screen fields
 
     C                   EVAL      #0IMIR = MIIMIR
 
      ** Format Date
 
     C                   MOVE      MIRCVD        WDate
     C                   EVAL      WYear = %SUBST(WDate:1:2)
     C                   EVAL      WMon = %SUBST(WDate:3:2)
     C                   EVAL      WDay = %SUBST(WDate:5:2)
 
     C                   MOVE      WMon          X
     C                   MOVE      MONTHS(X)     WMonth
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      #0DATE = WMonth + WDay + WYear
     C                   ELSE
     C                   EVAL      #0DATE = WDay + WMonth + WYear
     C                   ENDIF
 
     C                   MOVE      MIRCVT        WWRCVT
     C                   EVAL      #0TIME = %SUBST(WWRCVT:1:2) + ':' +
     C                                      %SUBST(WWRCVT:3:2)
 
     C                   EVAL      #0MSGT = MPMSGR
 
     C                   EVAL      #0OTRN = *BLANKS
     C                   EVAL      #0MSGG = *BLANKS
     C                   EVAL      #0OTRN = *BLANKS
     C                   EVAL      #0MSGG = *BLANKS
     C                   EVAL      #0NARR = *BLANKS
     C                   EVAL      *IN10  = *OFF
 
     C                   If        MPM94X <> *BLANKS
     C                   EVAL      #0OTRN = MPM94X
     C                   EVAL      #0MSGG = MPMSGR
     C                   EVAL      *IN10  = *ON
     C                   Endif
     C                   If        MPM995 <> *BLANKS
     C                   EVAL      #0OTRN = MPM995
     C                   EVAL      #0MSGG = '995'
     C                   EVAL      #0NARR = MPNAR1
     C                   EVAL      *IN10  = *ON
     C                   Endif
 
     C                   EVAL      #0ACCT = MPACTR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspScrn - Display output                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SrChkActn                                             *
      *                                                               *
      *****************************************************************
     C     SRDspScrn     BEGSR
 
      ** Display screen until F3 is pressed
 
     C                   DOW       *INKC = *OFF
 
     C                   EVAL      WPIMIR = #1IMIR
     C                   EVAL      WPDATE = #1DATE
     C                   EVAL      WPTIME = #1TIME
     C                   MOVE      DSINPUT       WPInput
 
      ** If no record read, disable SFLDSP and write 'No Details'
      ** record format
 
     C                   IF        WRrn = *ZERO And
     C                             WCnt = *ZERO
 
     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN06 = *OFF
     C                   WRITE     ME000080F0
     C                   WRITE     ME000080F1
     C                   WRITE     ME000080F2
     C                   EXFMT     ME000080C0
 
     C                   EXSR      SrChkActn
 
     C                   ELSE
 
      ** Display subfile record
 
     C                   EVAL      *IN06 = *ON
     C                   WRITE     ME000080F0
     C                   WRITE     ME000080F1
     C                   EXFMT     ME000080C0
 
     C                   EXSR      SrChkActn
 
     C                   ENDIF
 
      ** If F3 is pressed, end the program
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkActn - Check action made after display of screen        *
      *                                                               *
      *  Called by: SRDspScrn                                         *
      *                                                               *
      *  Calls: SrChkIn, SrBldSubf, SREnquire                         *
      *                                                               *
      *****************************************************************
     C     SRChkActn     BEGSR
 
     C                   EVAL      WPIMIR = #1IMIR
     C                   EVAL      WPDATE = #1DATE
     C                   EVAL      WPTIME = #1TIME
 
      ** Check if positioning required or selection made
 
     C                   IF        DSINPUT <> WPInput
 
      ** Check input fields
 
     C                   EXSR      SRChkIn
 
      ** Rebuild subfile
 
     C                   EXSR      SRBldSubf
 
     C                   ELSE
 
      ** Process if there is an enquiry
 
     C                   IF        WRrn <> *ZERO
     C                   EXSR      SREnquire
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkIn - Check Input fields                                 *
      *                                                               *
      *  Called by: SRChkActn                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkIn       BEGSR
 
     C                   EVAL      WSIMIR = 'N'
     C                   EVAL      WSDATE = 'N'
     C                   EVAL      WSTIME = 'N'
     C                   EVAL      WSMSGT = 'N'
     C                   EVAL      WSOTRN = 'N'
 
     C                   IF        #1IMIR <> *BLANKS
     C                   EVAL      WSIMIR = 'Y'
     C                   ENDIF
 
     C                   IF        #1DATE <> *BLANKS
     C                   EVAL      WSDATE = 'Y'
     C                   ENDIF
 
     C                   IF        #1TIME <> *BLANKS
     C                   EVAL      WSTIME = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkRec - Check Record if the same with selection           *
      *                                                               *
      *  Called by: SRBldSubf                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkRec      BEGSR
 
     C                   EVAL      WRecOk = 'Y'
 
     C                   IF        WSIMIR = 'Y'
     C                   EVAL      Pos = %scan(%trim(#1IMIR) : MPIMIR)
     C                   ENDIF
 
     C                   IF        WSDATE = 'Y' AND
     C                             #1DATE <> #0DATE OR
     C                             WSTIME = 'Y' AND
     C                             #1TIME <> #0TIME OR
     C                             WSIMIR = 'Y' AND
     C                             Pos    =  *ZEROS
     C                   EVAL      WRecOk = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnquire - Process enquiry on records                       *
      *                                                               *
      *  Called by: SRChkActn                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SREnquire     BEGSR
 
     C                   EVAL      PRCODE = *BLANKS
     C                   EVAL      WArTrn = *BLANKS
     C                   Z-ADD     0             WX1
 
     C                   DOU       *IN05 = *ON
     C                   READC     ME000080S0                             05
 
     C                   DOW       *IN05 = *OFF AND
     C                             #0ACTN = *BLANK
     C
     C                   UPDATE    ME000080S0
     C                   READC     ME000080S0                             05
     C                   ENDDO
 
     C                   IF        *IN05 = *OFF
     C                   EVAL      WX1 = WX1 + 1
     C                   EVAL      WArTrn(WX1) = #0OTRN
     C                   EVAL      #0ACTN = *BLANKS
     C                   UPDATE    ME000080S0
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WX1 > 0
     C                   Z-ADD     WX1           WX2
     C                   Z-ADD     1             WX1
 
     C                   DOW       WX1 <= WX2 AND
     C                             PRCODE <> '12'
 
     C                   EVAL      PFILA = *BLANKS
 
      ** If F8 pressed process next selection
 
     C                   IF        PRCODE = '08'
     C                   EVAL      WX1 = WX1 + 1
     C                   ENDIF
 
      ** If F9 pressed process previous selection
 
     C                   IF        PRCODE = '09'
     C                   EVAL      WX1 = WX1 - 1
     C                   ENDIF
 
      ** If single selection suppress F8 and F9
 
     C                   IF        WX2 = 1
     C                   EVAL      PFILA = 'S'
     C                   ENDIF
 
      ** If first selection suppress F9
 
     C                   IF        WX1 = 1 AND
     C                             PFILA <> 'S'
     C                   EVAL      PFILA = 'F'
     C                   ENDIF
 
      ** If last selection suppress F8
 
     C                   IF        WX1 = WX2 AND
     C                             PFILA <> 'S'
     C                   EVAL      PFILA = 'L'
     C                   ENDIF
 
     C                   EVAL      PTRNO = WArTrn(WX1)
 
     C                   CALL      'MEC0600'
     C                   PARM                    PTRNO
     C                   PARM                    PCFMT
     C                   PARM      'E'           PACTN
     C                   PARM                    PFILA
     C                   PARM                    PRCODE
     C                   PARM      '0'           PERROR
 
     C                   IF        PERROR <> '0'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PCFMT = BGCFMT
     C                   ENDIF
 
     C                   EVAL      #0USER = PSUSER
     C                   EVAL      #0RUND = BJMRDT
     C                   EVAL      #0WSID = PSJOBNAME
     C                   EVAL      #0SLSH = '/'
     C                   EVAL      #1SLSH = '/'
     C                   EVAL      WDAS1 = '-'
     C                   EVAL      WDAS2 = '-'
     C                   EVAL      WDAS3 = '-'
     C                   EVAL      WDAS4 = '-'
     C                   EVAL      WColon1 = ':'
     C                   EVAL      WColon2 = ':'
 
     C                   EVAL      *IN03 = *ON
 
     C     KMEP          KLIST
     C                   KFLD                    KeyIMIR
     C                   KFLD                    KeyMSGR
     C                   KFLD                    KeyACTR
 
     C                   ENDSR
      **********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
**  CPY@
(c) Finastra International Limited 2002
** MONTHS - Months Short Names
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
