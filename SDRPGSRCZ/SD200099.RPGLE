     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD GVC Codes Processing')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD200099 - Midas SD GVC Codes Processing                     *
      *                                                               *
      *  Function : This module Copies the GVC codes from the         *
      *             Deliverable file to Live file when Input is 'Y'   *
      *             and deletes the GVC codes from Live file when 'N' *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL152             Date 02Dec13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22611           Date 02Feb09               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL152 - Include Transaction Type Identification Code on     *
      *           MT940/MT950 (Recompile)                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22611 - German Features initialization pgm error          *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas SD Network Transaction code Deliverable file
      *
     FSDNCDDL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Network Transaction code Live file
      *
     F*DNTCDL0**UF A E           K DISK    INFSR(*PSSR) COMMIT                              BUG22611
     FSDNTCDL0  UF A E           K DISK    INFSR(*PSSR)                                     BUG22611
     F                                     PREFIX(L)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures. They have meaningful
      ** names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WNwrk           S              6A
     D PBasNwrk        S              6A
     D PNwrk           S              6A
     D PCopy           S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   SELECT
      *
      ** Copy all the GVC codes
      *
     C                   WHEN      PCopy = 'Y'
      *
      ** To avoid duplicate records
      *
     C     PNWrk         CHAIN     SDNTCDL0
     C                   IF        NOT %FOUND(SDNTCDL0)
     C                   EVAL      WNwrk = PBasNwrk
      *
     C     WNwrk         SETLL     SDNCDDL0
     C     WNwrk         READE     SDNCDDL0
      *
     C                   DOW       NOT %EOF(SDNCDDL0)
      *
     C                   EVAL      LNTNWRK = PNwrk
     C                   EVAL      LNTTRCD = NTTRCD
     C                   EVAL      LNTDESC = NTDESC
      *
     C                   WRITE     SDNTCDD0
      *
     C     WNwrk         READE     SDNCDDL0
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Delete all GVC codes
      *
     C                   WHEN      PCopy = 'N'
     C     PNwrk         SETLL     SDNTCDL0
     C     PNwrk         READE     SDNTCDL0
      *
     C                   DOW       NOT %EOF(SDNTCDL0)
     C                   DELETE    SDNTCDL0
     C     PNwrk         READE     SDNTCDL0
     C                   ENDDO
      *
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PBasNwrk
     C                   PARM                    PNwrk
     C                   PARM                    PCopy
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA
      ** as an external data area
      *
      /COPY ZACPYSRC,PSSR_ILE
**  CPY@
(c) Finastra International Limited 2008
