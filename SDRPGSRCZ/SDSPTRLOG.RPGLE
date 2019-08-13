     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate Support Log Setup Module')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSPTRLOG - SD Spot Rate Support Log Setup Module            *
      *                                                               *
      *  Function:  This module will write to the standard log        *
      *             file if the support system is active.             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054039           Date 05Aug19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8205            Date 22Aug05               *
      *                 BUG8130            Date 10Aug05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054039 - DBU_SPTR did not update the spot rate (Recompile) *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROC - Convert file fields into screen format              *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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

     D SPTRFilFmt    E DS                  EXTNAME(SDVSPTRPD)
      ** Midas SD Spot Rates

     D SPTRScnFmt    E DS                  EXTNAME(SDSPTRPD)
      ** Midas SD Spot Rates Format Definition File

     D SPTRExtDta    E DS                  EXTNAME(SDSPTXPD)
      ** Midas SD Spot Rate Details Extra Data Layout File

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PSTS            S             24A
     D TRANSDTL        S           5800A
     D PCYNM           S             14A
     D PDLCY           S              1A
     D PSWCY           S              3A
     D PVSEU           S              3A
     D PSPR2           S             14A
     D PMDI2           S              1A
     D PDCY2           S              1A
     D PSWC2           S              3A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Convert file fields into screen format

     C                   EXSR      SRPROC

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Convert file fields into screen format               *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SDSPTRCVT                                         *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR

     C                   EVAL      TRANSDTL = *BLANKS

     C                   EVAL      DDACTN = AVTYLC

     C                   CALLB     'SDSPTRCVT'

     C                   PARM                    RetCodeOut
     C                   PARM                    SPTRFilFmt
     C                   PARM                    SPTRScnFmt
     C                   PARM                    PCYNM
     C                   PARM                    PDLCY
     C                   PARM                    PSWCY
     C                   PARM                    PVSEU
     C                   PARM                    PSPR2
     C                   PARM                    PMDI2
     C                   PARM                    PDCY2
     C                   PARM                    PSWC2

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
     C                   EVAL      TRANSDTL = SPTRScnFmt + SPTRExtDta
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
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** INPUT
      ** =====

      ** Return Code
     C                   PARM                    RetCodeIn

      ** Midas SD Valid Spot Rates
     C                   PARM                    SPTRFilFmt

      ** OUTPUT
      ** ======

      ** Data Replication Details Screen Format
     C                   PARM                    TRANSDTL

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
