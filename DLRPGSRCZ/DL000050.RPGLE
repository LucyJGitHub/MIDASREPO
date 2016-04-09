     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL IRS Rate Fixing')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000050   - IRS Rate Fixing                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7096            Date 11May05               *
      *                 CDL027  *CREATE    Date 10Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7096- Do not select Overnight Index Swaps or Average Rate *
      *           CCF deals.                                          *
      *  CDL027 - Back-valued base rate changes                       *
      *                                                               *
      *****************************************************************
      * SUBROUTINES:                                                  *
      *****************************************************************
      *                                                               *
      * Standard:                                                     *
      * ---------                                                     *
      * *inzsr                                                        *
      * *pssr                                                         *
      *                                                               *
      * Custom:                                                       *
      * -------                                                       *
      * sr_endpgm                                                     *
      * sr_process                                                    *
      * sr_valid                                                      *
      *                                                               *
      *****************************************************************
      * INDICATOR USAGE                                               *
      *****************************************************************
      *                                                               *
      * 40 - NOF                                                      *
      * 41 - Record lock                                              *
      * 66 - Match Y/N                                                *
      * 97 - Record lock                                              *
      * 98 - NOF                                                      *
      * LR - Last Record                                              *
      * U7 - Error                                                    *
      * U8 - Error                                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALSDG   IP   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDGF:SAVE)
     F                                     PREFIX(SV)
      ** RTV: Midas IRS Deals File (saved copy)
 
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     ignore(DEALSDAf)
     F                                     ignore(DEALSDBf)
     F                                     ignore(DEALSDCf)
     F                                     ignore(DEALSDDf)
     F                                     ignore(DEALSDEf)
     F                                     ignore(DEALSDFf)
     F                                     RENAME(DEALSDGF:IRS)
     F                                     PREFIX(IR)
      ** RTV: Midas IRS Deals File
 
     FDLIRLFL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLIRLFD0:DG)
      ** UPD: IRS Last Interest Rate Fix File
 
     FDL000050AUO    E             PRINTER
      ** Bulk Short Rate Amendments printer file - audit
 
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
 
      ** Include the MM standard declares
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
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for Currency Details file
 
     D   SDBSRT      E DS                  EXTNAME(SDBSRTPD)
      **Base Rate Code details accessed via access programme
 
     D   ZADEC         S              1  0
      **Decimal data length passed as a parameter to ZALIGN
 
     D   ZADIG         S              2  0
      **Digital data length passed as a parameter to ZALIGN
 
     D   ZFIELD        S             16A
      **Field Passed to ZALIGN on which the work is done
 
     D   ZALIGNok      S              1A
      **Indicator to show whether or not ZALIGN was successful
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
     D                 DS
     D  a1brcd                 1      2
     D  a1brcd#                1      2  0
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      *
      * Validate
      *
     c                   exsr      sr_valid
      *
      * If match - process
      *
     c  n66              exsr      sr_process
      *
      * End program
      *
     clr                 exsr      sr_endpgm
      *
     c/eject
      *****************************************************************
     csr   sr_valid      begsr
      *****************************************************************
      *
     c                   eval      *in66=*off
      *
     c                   if        svdtyp <>'RS' and svdtyp <>'RX' and
     c                             svdtyp <>'RP' and svdtyp <>'RR' and
     c                             svdtyp <>'RF'
     c                   eval      *in66=*on
      *
     c                   else
      *
      * Access IRS deals file
      *
     C                   dou       *in41=*off
     C     svdlno        chain     irs                                4041
     C                   enddo
      *
     c                   select
      *
      * Check if live valid deal
      *
     c                   when      *in40=*on or irreci<>'D'
     c                   eval      *in66=*on
      *
      * Check if dates match
      *
     c                   when      svuinfd=iruinfd and svtinfd=irtinfd
     c                   eval      *in66=*on
      *
     c                   endsl
      *                                                                                      BUG7096
     c     *IN66         ifeq      *OFF                                                      BUG7096
     c                   exsr      sr_valid2                                                 BUG7096
     c                   endif                                                               BUG7096
      *
     c                   endif
      *
     C                   ENDSR
      *
     c/eject
      *****************************************************************                      BUG7096
     csr   sr_valid2     begsr                                                               BUG7096
      *****************************************************************                      BUG7096
      * If Overnight Index Swap deal then ignore                                             BUG7096
     c                   if        irdtyp = 'RS'                                             BUG7096
      *                                                                                      BUG7096
     c                   if        irUicfr = 'O' or irTicfr = 'O'                            BUG7096
     c                   eval      *in66=*on                                                 BUG7096
     c                   endif                                                               BUG7096
      *                                                                                      BUG7096
     c                   endif                                                               BUG7096
      * If Caps, Collars or Floors & Average Rate Method field = 'Y' then ignore             BUG7096
     c                   if        irdtyp = 'RP' or irdtyp = 'RR'                            BUG7096
     c                             or irdtyp = 'RF'                                          BUG7096
      *                                                                                      BUG7096
     c                   testb     '3'           irUDSTI                  86                 BUG7096
     c     *IN86         ifeq      *ON                                                       BUG7096
     c                   eval      *in66=*on                                                 BUG7096
     c                   endif                                                               BUG7096
      *                                                                                      BUG7096
     c                   testb     '3'           irTDSTI                  87                 BUG7096
     c     *IN87         ifeq      *ON                                                       BUG7096
     c                   eval      *in66=*on                                                 BUG7096
     c                   endif                                                               BUG7096
      *                                                                                      BUG7096
     c                   endif                                                               BUG7096
      *                                                                                      BUG7096
     C                   ENDSR                                                               BUG7096
      *                                                                                      BUG7096
     c/eject                                                                                 BUG7096
      *****************************************************************
     C     sr_process    BEGSR
      ******************************************************************
      *
      * Access IRS file
      *
     C     irdlno        setll     dg
     c                   eval      *in98=*off
     c                   z-add     *zeros        cntr              1 0
     c                   move      *blanks       ot                2
      *****************
      * Case of amend *
      *****************
     C                   dou       *in97=*off
     C     irdlno        reade     dg                                   9798
     C                   enddo
      *
     c                   dow       *in98=*off
      *
      * If "Ours"
      *
     c                   if        a1side='O'
     c                   movel     'O'           ot
     c                   if        irUCUCY=a1curc and irubrtt=a1brcd# and
     c                             svuinfd<>iruinfd and a1lifd<>svuinfd
     c                   eval      a1lifd=svuinfd
     c                   update    dg
     c                   add       1             rcount
     c                   add       1             cntr
     c                   endif
     c                   endif
      *
      * If "Theirs"
      *
     c                   if        a1side='T'
     c                   move      'T'           ot
     c                   if        irtCUCY=a1curc and irtbrtt=a1brcd# and
     c                             svtinfd<>irtinfd and a1lifd<>svtinfd
     c                   eval      a1lifd=svtinfd
     c                   update    dg
     c                   add       1             rcount
     c                   add       1             cntr
     c                   endif
     c                   endif
      *
     C                   dou       *in97=*off
     C     irdlno        reade     dg                                   9798
     C                   enddo
      *
     C                   enddo
      ******************
      * Case of insert *
      ******************
     c                   if        cntr<2
      *
     C                   eval      a1dlno=irdlno
      *
      * If "Ours"
      *
     c                   if        svuinfd<>iruinfd and ot=*blanks or
     c                             svuinfd<>iruinfd and ot=' T'
     c                   eval      ot='OT'
     C                   eval      a1curc=irucucy
     C                   move      irubrtt       a1brcd
     c                   eval      a1lifd=svuinfd
     C                   eval      a1pram=irupamt
     C                   eval      a1side='O'
     C                   eval      a1dtyp=irdtyp
     c                   write     dg
     c                   add       1             rcount
     c                   endif
      *
      * If "Theirs"
      *
     c                   if        svtinfd<>irtinfd and ot=*blanks or
     c                             svtinfd<>irtinfd and ot='O '
     c                   eval      ot='OT'
     C                   eval      a1curc=irtcucy
     C                   move      irtbrtt       a1brcd
     c                   eval      a1lifd=svtinfd
     C                   eval      a1pram=irtpamt
     C                   eval      a1side='T'
     C                   eval      a1dtyp=irdtyp
     c                   write     dg
     c                   add       1             rcount
     c                   endif
      *
     c                   endif
      *
     C                   ENDSR
      *
     c/eject
      *****************************************************************
      * End Program
      *****************************************************************
     C     sr_endpgm     BEGSR
      *
     c                   if        rcount>*zeros
     c                   write     control
     c                   else
     c                   write     nodtls
     c                   endif
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     PSProcPgm     DBPGM
      *
      ** Retrieve title
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM      'CDL0007'     MSGDNB            7
     C                   PARM      'DRSMM     '  MSGNM            10
     C                   PARM      *BLANK        TITLE            80
      *
     c                   movel     title         #1titl
      *
      ** Access bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Write audit printer file header
      *
     c                   write     headau
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   z-add     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDif
      *
      ** Access General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   z-add     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDif
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
      * *PSSR  - INITIAL PROCESSING
      *****************************************************************
     C     *PSSR         BEGSR
      *
     c                   write     dberror
     c                   seton                                        U7U8
     c                   dump
     c                   seton                                        lr
     c                   return
      *
     C                   ENDSR
      *
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
