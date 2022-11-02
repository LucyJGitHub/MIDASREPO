     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  XX118006 - SE Position Settlement check/delete               *
      *                                                               *
      *  Function: This module receives a set of parameters to access *
      *            the Position Settlement File to check whether the  *
      *            Position Settlement was generated during the I/C.  *
      *            It is called from SE4859/SE4860                    *
      *                                                               *
      *  Called By: XX118004 - Generate Position Settlements - Depots *
      *             XX118008 - Generate Position Settlements - Cust   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Last Amend No. HUT118  *CREATE    Date 16Dec20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT118 - Position Settlements Online Generation              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    88         File lock record                                *
      *    89         End of file                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  sr_adjust    - Recalculate Nominal Amount                    *
      *  sr_audit     - Audit Printer file etc. processing at last call
      *  sr_auth      - Process for System Value = "AUTH"             *
      *  sr_delete    - Mark record in POSETD as deleted              *
      *  sr_endp      - End program processing (not the last call)    *
      *  sr_mainp     - Main processing                               *
      *  sr_none      - Process for System Value = "NONE"             *
      *  sr_notzero   - Process if Calculated Total Nominal Amount <>0*
      *  sr_upd_file  - At EOF update POSETA                          *
      *  sr_upd_parms - At EOF update output parameters               *
      *  sr_zero      - Process if Calculated Total Nominal Amount = 0*
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Position Settlement by Security (POSETD MBR *ALL)
     FPOSET5    UF   E           K DISK    INFSR(*PSSR) USROPN COMMIT
      *
      ** Midas SE Position Settlements - Audit
     FPOSETA    UF A E             DISK    INFSR(*PSSR) USROPN COMMIT
      *
      * Audit Report
     FXX118006AUO    E             PRINTER INFSR(*PSSR) USROPN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Externally described DS Projected Balance Update
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D PPOSET        E DS                  EXTNAME(POSETD)
      ** +--------------------------------------+
     D  Keyfld         DS
     D  SPBCA                  1      3
     D  SPSSH                  4     13
     D  SPCPY                 14     19
     D  SPDUD                 20     24  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      *
      * Check Audit Flag to generate Audit file
      *
     c     zaudit        caseq     'L'           sr_audit
     c                   endcs
      *
      * Main process
      *
     c                   exsr      sr_mainp
      *
      * End  process
      *
     c                   exsr      sr_endp

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_AUDIT - Audit Printer File - related processing           *
      *                                                               *
      *****************************************************************
     c     sr_audit      begsr
      *
      ** Final processing only if previous processing was done
      *
     c     once          ifeq      'Y'
      *
      ** Update POSETA (if there are any records were marked as deleted)
      *
     c     del_rcds      casne     *zeros        sr_upd_file
     c                   endcs
      *
      ** Output to Audit Printer file (either "no records processed" or
      ** totals).
      *
     c     del_rcds      ifeq      *zeros
     c                   write     nodtls
     c                   else
     c                   write     control
     c                   endif
      *
      ** Close Audit Printer file.
      *
     c                   close     XX118006AU

     c                   endif

      ** Return to the calling program with *INLR *ON
      *
     c                   move      *on           *inlr
     c                   return

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_MAINP - Main Processing                                   *
      *                                                               *
      *****************************************************************
     c     sr_mainp      begsr

      *
     C*****              MOVE      @SEQU         @@SEQU            3            HUT118
     C*****@SEQU         IFEQ      *ZEROS                                       HUT118
     C*****              MOVE      *BLANKS       @@SEQU            3            HUT118
     C*****              END                                                    HUT118
      *
      ** Open POSET5
      *
     c                   open      poset5
      *
      ** Initialise workfields and indicators used
      *
     c                   z-add     *zeros        znwcmp_clc       15 0
     c                   move      *off          *in89
      *
      ** Read all records in POSET5 with the specified key and process
      ** non-deleted records according to the Check Flag and System Value.
      *
     c     Parm_Key      setll     posetdf

     c     *in88         doueq     *off
     c     Parm_Key      reade     posetdf                              8889
     c                   enddo

     c     *in89         doweq     *off

     c     reci          ifne      '*'
     c     reci          andne     'M'
     c     dept          andeq     ZCudep

     c**** CSE054        ifeq      'Y'                                    HUT118
     c**** PEvt          andeq     'DV'                                   HUT118
     c**** @@SEQU        andeq     PDESEQ                                 HUT118
     c**** CSE054        orne      'Y'                                    HUT118
     c**** Pevt          orne      'DV'                                   HUT118

     c                   select

     c     zchkfl        wheneq    'U'
     c     PosSettlAdj   caseq     'AUTH'        sr_auth
     c     PosSettlAdj   caseq     'NONE'        sr_none
     c                   cas                     sr_adjust
     c                   endcs

     c     zchkfl        wheneq    'C'
     c                   cas                     sr_adjust
     c                   endcs

     c                   endsl
     c****************** endif                                            HUT118

     c                   endif

     c     *in88         doueq     *off
     c     Parm_Key      reade     posetdf                              8889
     c                   enddo

     c                   enddo
      *
      ** Close POSET5
      *
     c                   close     poset5

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_ENDP  - End Program Processing                            *
      *                                                               *
      *****************************************************************
     c     sr_endp       begsr
      *
      ** Update output parameters
      *
     c                   exsr      sr_upd_parms
      *
      ** Return to the calling program without switching *inlr *ON
      *
     c                   return
      *
     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_AUTH    -Process if System Value is "AUTH"                *
      *                                                               *
      *****************************************************************
     c     sr_auth       begsr
      *
      * If Position Settlement is authorised - adjust Nominal Amount
      * If Position Settlement is not authorised - mark for deletion
      *
     c     paui          caseq     'Y'           sr_adjust
     c     paui          casne     'Y'           sr_delete
     c                   endcs

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_NONE    -Process if System Value is "NONE"                *
      *                                                               *
      *****************************************************************
     c     sr_none       begsr
      *
      * Mark for deletion unconditionally
      *
     c                   exsr      sr_delete

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_DELETE  -Mark record in POSETD as deleted                 *
      *                                                               *
      *****************************************************************
     c     sr_delete     begsr

      *
     c     PAUI          ifeq      'Y'
     c     @PHASE        ANDEQ     'I'
     c                   MOVE      *BLANKS       Z#BSTS
     c                   MOVEL     PPOSET        Z#BSTS
     c                   END
      *
     c                   move      '*'           reci
     c                   z-add     BJRDNB        lcd
     c                   move      'D'           chtp

     c     mt5g          ifeq      'Y'
     c                   move      'R'           mt5g
     c                   endif

     c                   update    posetdf
      * Projected Mov update
      *
     c     PAUI          ifeq      'Y'
     c     @PHASE        ANDEQ     'I'
     c                   MOVE      *BLANKS       Z#ASTS
     c                   MOVEL     PPOSET        Z#ASTS
     c                   CALL      'AOOUPSU0'
     c                   PARM                    PRtcd
     c                   PARM                    Z#BSTS
     c                   PARM                    Z#ASTS
     c     Prtcd         ifeq      '*ERROR*'
     C     *LOCK         IN        LDA
     c                   MOVE      PBCA          SPBCA
     c                   MOVE      PSSH          SPSSH
     c                   MOVE      PCPY          SPCPY
     c                   MOVE      PDUD          SPDUD
     C                   EVAL      DBKEY = KEYFLD
     C                   EVAL      DBFILE = 'AOOUPSU0'
     C                   EVAL      DBASE = 080
     C                   OUT       LDA
     c                   write     dberror
     c                   eval      zrtncd = 'ERROR  '
     C                   EXSR      *PSSR
     c                   END
     c                   END
      *
     c*****              commit                                           HUT118

     c                   add       1             del_rcds

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_ADJUST  -Recalculate Nominal Amount                       *
      *                                                               *
      *****************************************************************
     C     sr_adjust     begsr

      *
      * Add Nominal Amount to total
      *
     c                   add       pnmp          znwcmp_clc
      *
     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_UPD_PARMS -update output parameters                       *
      *                                                               *
      *****************************************************************
     C     sr_upd_parms  begsr
      *
      * Copy CTYP from the last record read in POSET5 to a workfield
      *
     c                   move      ctyp          ctyp_last         1
      *
      * Temporarily set the New Pay/Receive Indicator according to the
      * calculated Total Nominal Amount
      *
     c                   select
      *
      * Process negative (debit or credit)
      *
     c     znwcmp_clc    whenlt    *zeros

     c     ctyp_last     ifeq      'D'
     c                   move      'P'           znwpre_work       1
     c                   else
     c     ctyp_last     ifeq      'C'
     c                   move      'R'           znwpre_work
     c                   endif
     c                   endif
      *
      * Process positive (debit or credit)
      *
     c     znwcmp_clc    whengt    *zeros

     c     ctyp_last     ifeq      'D'
     c                   move      'R'           znwpre_work
     c                   else
     c     ctyp_last     ifeq      'C'
     c                   move      'P'           znwpre_work
     c                   endif
     c                   endif
      *
      * Process zero value
      *
     c     znwcmp_clc    wheneq    *zeros
     c                   move      *blanks       znwpre_work

     c                   endsl
      *
      * Calculate the difference between the calculated Total Nominal
      * Amount and the Amount received in input and update output parameters
      * (new Total Nominal Amount, new Pay/Receive Indicator & the Found Y/N
      * field)
      *
     c     znwcmp_clc    caseq     *zeros        sr_zero
     c     znwcmp_clc    casne     *zeros        sr_notzero
     c                   endcs

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_NOTZERO -process if Calculated Total Nominal Amount <> 0  *
      *                                                               *
      *****************************************************************
     c     sr_notzero    begsr

     c                   eval      znwcmp = zcumcp - znwcmp_clc

     c                   select
      *
      * Process negative (debit or credit)
      *
     c     znwcmp        whenlt    *zeros

     c     ctyp_last     ifeq      'C'
     c                   move      'R'           znwpre
     c                   else
     c     ctyp_last     ifeq      'D'
     c                   move      'P'           znwpre
     c                   endif
     c                   endif
      *
      * Process positive (debit or credit)
      *
     c     znwcmp        whengt    *zeros

     c     ctyp_last     ifeq      'C'
     c                   move      'P'           znwpre
     c                   else
     c     ctyp_last     ifeq      'D'
     c                   move      'R'           znwpre
     c                   endif
     c                   endif
      *
      * Process zero value
      *
     c     znwcmp        wheneq    *zeros
     c                   move      *blanks       znwpre

     c                   endsl

     c                   move      'Y'           zfound

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_ZERO    -process if Calculated Total Amount is zero       *
      *                                                               *
      *****************************************************************
     c     sr_zero       begsr

     c                   eval      znwcmp = zcumcp

     c                   move      zppre         znwpre

     c                   move      'N'           zfound

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_UPD_FILE -update records in POSETA                        *
      *                                                               *
      *****************************************************************
     C     sr_upd_file   begsr

     c                   open      poseta
      *
      * Update POSETA with the number of deleted records
      *
     c                   read      posetaf                              8889


     c                   eval      node = node + del_rcds
     c                   eval      nore = nore - del_rcds
     c     *in89         ifeq      *off
     c                   update    posetaf
     c                   else
     c                   eval      tnlu =  0
     c                   eval      node =  del_rcds
     c                   eval      nore = 0
     c                   write     posetaf
     c                   endif
     c*****              commit                                           HUT118

     c                   close     poseta

     c                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Branch
      *
     C                   PARM                    ZBRCH             3
      *
      ** Security
      *
     C                   PARM                    ZSECT            10
      *
      ** Depot/Customer
      *
     C********           PARM                    ZDEPOT            6 0          HUT118
     C                   PARM                    ZDEPOT            6            HUT118
      *
      ** Due Date
      *
     C                   PARM                    ZDUEDT            5 0
      *
      ** Event Type
      *
     C                   PARM                    ZSDET             2
      *
      ** Portfolio
      *
     C                   PARM                    ZPTFR             4
      *
      ** Check/Update Flag
      *
     C                   PARM                    ZCHKFL            1
      *
      ** Nominal Amount (in)
      *
     C                   PARM                    ZCUMCP           15 0
      *
      ** Pay/Receive Indicator (in)
      *
     C                   PARM                    ZPPRE             1
      *
      ** Customer Depot (CDPT from CDEPP)
      *
     C                   PARM                    ZCUDEP            6
      *
     C                   PARM                    ZCRTT             2
      *
     C***********        PARM                    @SEQU             3 0          HUT118
      *
     C*******************PARM                    CSE054            1
      *
     C                   PARM                    @PHASE            1
      *
      *
      ** OUTPUT
      ** ======
      *
      ** Found Indicator Y/N
      *
     C                   PARM                    ZFOUND            1
      *
      ** Nominal Amount (new -out)
      *
     C                   PARM                    ZNWCMP           15 0
      *
      ** Pay/Receive Indicator (new -out)
      *
     C                   PARM                    ZNWPRE            1
      *
      ** Total Due Amount (returned as 0 for non-CP (non-Coupon) events
      *
     C                   PARM                    ZNWDUE           15 0
      *
      ** Audit File-related parameter: F - 1st call, L - last call
      *
     C                   PARM                    ZAUDIT            1
      *
      ** Return Code
      *
     C                   PARM                    ZRTNCD            7

      *
      ** If it is the first in the process the program is called (ZAUDIT=F)
      ** - open Audit Printer file.
      ** If it is the last in the process the program is called (ZAUDIT=L)
      ** - skip initialisation.
      *
     c     zaudit        ifeq      'F'
     c                   move      'Y'           once              1
     c                   open      XX118006AU
     c                   else
     c     zaudit        cabeq     'L'           endinz
     c                   endif
      *
      ** Key fields for POSET5
      *
     C     Parm_Key      klist
     C                   kfld                    ZBRCH
     C                   kfld                    ZSECT
     C                   kfld                    ZDEPOT
     C                   kfld                    ZDUEDT
     C                   kfld                    ZSDET
     C                   kfld                    ZPTFR

      ** Read in Installation Data and print Audit report headings

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY

     c                   write     headau

      ** Database error.

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     c                   write     dberror
     c                   eval      zrtncd = 'ERROR  '
     C                   EXSR      *PSSR
     C                   ENDIF

      * CSE053's system value is not required in here, forcing NONE instead

     C                   movel     'NONE'        PosSettlAdj       4                          HUT118

      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS

     C     endinz        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2020
