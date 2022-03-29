     H DEBUG
     H DATEDIT (*DMY)
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas ME Purge Incoming MX Msgs - phase 2/2')          *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME2220 - Purge Incoming MX Transactions - Phase 2 of 2       *
      *                                                               *
      *  Function:  This program runs for a pre-defined amount of     *
      *  time and deletes all the I.M.M transactions that may be      *
      *  purged from the IMM files.                                   *
      *                                                               *
      *  Called By: MEC2230 - Incoming MX Message Purge Phase 2 of 2  *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059755           Date 29Mar22               *
      *  Prev Amend No. MD059676           Date 09Mar22               *
      *                 CSW122  *CREATE    Date 04Oct21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059755 - Various records in MSIXISOPD and MSMXISOPD have   *
      *             no value date                                     *
      *  MD059676 - Program dump in job MS_MX_IMM due to duplicate    *
      *             data (Recompile)                                  *
      *  CSW122 - SWIFT ISO20022 Changes                              *
      *                                                               *
      *****************************************************************
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  10    Incoming MX Index file EOF indicator                   *
      *  20    Incoming MX Header file EOF indicator                  *
      *  30    ME Main details file EOF indicator                     *
      *  40    ME Element details EOF indicator                       *
      *  50    First cycle                                            *
      *  90    Purge file EOF indicator                               *
      *                                                               *
      *  LR    End program                                            *
      *                                                               *
      *****************************************************************
      /EJECT

      ** Incoming MX Message Purge File

     FMEMXINRMPDUF   E           K DISK    infsr(srfile)
     F                                     usropn
     F                                     commit

      ** MX Message Header file

     FMSMXISOL1 UF   E           K DISK    infsr(srfile)
     F                                     usropn
     F                                     commit

      ** MX Message Index file

     FMSIXISOL2 UF   E           K DISK    infsr(srfile)
     F                                     usropn
     F                                     commit

      ** ME MX Header file

     FMEISOML1  UF   E           K DISK    infsr(srfile)
     F                                     usropn
     F                                     commit

      ** ME MX Details file

     FMEISODL2  UF   E           K DISK    infsr(srfile)
     F                                     usropn
     F                                     commit
      /EJECT

      **  /Copy point for Array Declarations

      /COPY ZSRSRC,ZDATE2Z1LE

      ** /Copy point for error processing declarations

      /COPY MECPYSRC,SRERRELE
      /COPY MECPYSRC,SRERRILE
      /EJECT

      ** Array containing Copyright statement

     D cpy@            S             80    dim(1) ctdata perrcd(1)

      ** Working field for message id

     D w@msgid         S             20A

      ** Working field for date conversion

     D***w@date          S              5S 0                                                MD059755
     D W@Date          S              6S 0                                                  MD059755

      ** Fields for getting system value

     D PSysVal1        C                   const('MxPurgeTime')
     D PRetCode        S              7A
     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A
     D alpurg          S              3S 0

      ** RUNDAT data area

     D RUNDTA        E DS                  extname(RUNDAT)

      ** Data structure for time/date comparison - time limit

     D dstl            DS
     D  tldate                 1      6  0
     D  tlddd                  1      2  0
     D  tldmm                  3      4  0
     D  tldyy                  5      6  0
      *
     D  tltime                 7     12  0
     D  tlthh                  7      8  0
     D  tltmm                  9     10  0
     D  tltss                 11     12  0

      ** Data structure for time/date comparison - current

     D dscu            DS
     D  cudate                 1      6  0
     D  cudyy                  1      2  0
     D  cudmm                  3      4  0
     D  cuddd                  5      6  0
      *
     D  cutime                 7     12  0
     D  cuthh                  7      8  0
     D  cutmm                  9     10  0
     D  cutss                 11     12  0

      ** Data structure for data conversion to Midas day no.

     D dscn            DS
     D  cndate                 1      6
     D  cndd                   1      2  0
     D  cnmm                   3      4  0
     D  cnyy                   5      6  0
      /EJECT

      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program                           *
      *  sr_purge      : Check for purgeable messages                 *
      *  srerr         : Error processing (on copysource)             *
      *  zdate1        : Date conversion (on copysource)              *
      *                                                               *
      *****************************************************************

      ** Set up copyright statement

     C                   movea     cpy@          bis@             80

      **  Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'main'        @STK(Q)

      ** Define entry parameters

     C     *entry        plist
     C                   parm                    w0rtn             7

      ** Initialise program

     C     *in50         ifeq      '0'
     C                   exsr      sr_init
     C                   end

      ** Read all message references that are to be purged

     C                   exsr      sr_read

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   seton                                        LR
      /EJECT

      *****************************************************************
      *                                                               *
      *  sr_read  : Read all message references that are to be purged *
      *                                                               *
      *  CALLED BY: mainline                                          *
      *                                                               *
      *  CALLS    :         -                                         *
      *                                                               *
      *****************************************************************

     C     sr_read       begsr

      ** Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'sr_read'     @STK(Q)

      ** Set limits to read all records

     C                   read      MEMXINRMPD                             90

      ** Read all records until end of time limit.
      ** The time limit is stored in the MEDTA data structure

     C     *in90         doweq     '0'

      ** Move Message Id to working field for use on short message id fields

     C                   eval      w@msgid = %trim(RMMXID)

      ** Purge all associated records for the message reference

     C                   exsr      sr_purge

      ** Delete Purge File record and commit all deletes

     C                   delete    @INRMPD
     C                   commit

      *  Update current time and date. UDATE is set in Header spec to
      *  be in the format DDMMYY.
      *
     C                   time                    cudttm           12 0
     C                   time                    cutime
     C                   z-add     cudttm        cudate

      ** Check if processing is still within the time limit.
      ** If not leave the processing after setting return code to send
      ** a message to Audit Log on MRUNQ.

     C     dscu          ifge      dstl
     C                   movel     'MIN0098'     w0rtn
     C                   leave
     C                   end

      ** Read next record

     C                   read      MEMXINRMPD                             90
      *
     C                   enddo

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      *****************************************************************
      *                                                               *
      *  sr_purge : Purge all records with the corresponding message  *
      *           : reference from the purge logs                     *
      *                                                               *
      *  CALLED BY: sr_read                                           *
      *                                                               *
      *  CALLS    : sr_mxindx                                         *
      *           : sr_mxhdr                                          *
      *           : sr_memain                                         *
      *           : sr_medtls                                         *
      *                                                               *
      *****************************************************************

     C     sr_purge      begsr

      ** Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'sr_purge'    @STK(Q)

      ** Read and purge records from MX Messages Index file

     C                   exsr      sr_mxindx

      ** Read and purge records from MX Messages Header file

     C                   exsr      sr_mxhdr

      ** Read and purge records from ME Main details file

     C                   exsr      sr_memain

      ** Read and purge records from ME Element details file

     C                   exsr      sr_medtls

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      *****************************************************************
      *                                                               *
      *  sr_mxindx:                                                   *
      *                                                               *
      *  CALLED BY: sr_purge                                          *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************

     C     sr_mxindx     begsr

      ** Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'sr_mxindx'   @STK(Q)

      ** Read the MX Index file

     C     KYMSIX        klist
     C                   kfld                    RMMXID
     C                   kfld                    RMUETR

     C     KYMSIX        setll     MSIXISOL2
     C     KYMSIX        reade     MSIXISOL2                              10

      ** If record found proceed with the purge process

     C     *in10         ifeq      '0'
     C                   delete    MSIXISD0
     C                   endif

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      *****************************************************************
      *                                                               *
      *  sr_mxhdr :                                                   *
      *                                                               *
      *  CALLED BY: sr_purge                                          *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************

     C     sr_mxhdr      begsr

      ** Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'sr_mxhdr'    @STK(Q)

      ** Read the MX Header file

     C     KYMSMX        klist
     C                   kfld                    RMMXID
     C                   kfld                    RMUETR
      *
     C     KYMSMX        setll     MSMXISOL1
     C     KYMSMX        reade     MSMXISOL1                              20

      ** Read file until the key changes

     C     *in20         doweq     '0'

      ** Delete the corresponding record and read the file again for another record
     C                   delete    MSMXISD0
      *
     C     KYMSMX        setll     MSMXISOL1
     C     KYMSMX        reade     MSMXISOL1                              20
      *
     C                   enddo

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      *****************************************************************
      *                                                               *
      *  sr_memain:                                                   *
      *                                                               *
      *  CALLED BY: sr_purge                                          *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************

     C     sr_memain     begsr

      ** Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'sr_mxindx'   @STK(Q)

      ** Read the MX Element header file

     C     KYMEMD        klist
     C                   kfld                    w@msgid
     C                   kfld                    RMUETR
      *
     C     KYMEMD        setll     MEISOML1
     C     KYMEMD        reade     MEISOML1                               30

      ** If record is found, proceed with the purge process

     C     *in30         ifeq      '0'

      ** Delete the record if found

     C                   delete    MEISOMD0
      *
     C                   endif

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      *****************************************************************
      *                                                               *
      *  sr_medtls:                                                   *
      *                                                               *
      *  CALLED BY: sr_purge                                          *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************

     C     sr_medtls     begsr

      ** Set up subroutine stack name

     C                   add       1             Q
     C                   movel     'sr_mxindx'   @STK(Q)

      ** Read the MX Element details file

     C     KYMEED        klist
     C                   kfld                    w@msgid
     C                   kfld                    RMUETR
      *
     C     KYMEED        setll     MEISODL2
     C     KYMEED        reade     MEISODL2                               40

      ** Read until end of file

     C     *in40         doweq     '0'

      ** Delete record from file then read the file again

     C                   delete    MEISODD0
      *
     C     KYMEED        setll     MEISODL2
     C     KYMEED        reade     MEISODL2                               40
      *
     C                   enddo
      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      *****************************************************************
      *                                                               *
      *  sr_init  : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: mainline                                          *
      *                                                               *
      *  CALLS    : srerr  - Error Processing                         *
      *                                                               *
      *****************************************************************

     C     sr_init       begsr

      **  Set up subroutine stack name

     C                   add       1             Q                 5 0
     C                   movel     'sr_init'     @STK(Q)

      ** Open Files

     C                   open      MEMXINRMPD
     C                   open      MSMXISOL1
     C                   open      MSIXISOL2
     C                   open      MEISOML1
     C                   open      MEISODL2

      ** Get Rundate information

     C     *DTAARA       define    RUNDAT        RUNDTA
     C                   in        RUNDTA
     C                   move      AGMRDT        WUMRDT            7            Midas Run date
     C                   move      AGRDNB        WURDNB            5 0          Run day number
     C                   move      AGSUC         WUSUC             1            Set up complete
     C                   move      AGDFF         WUDFF             1            Date Format
     C                   move      AGMBIN        WUMBIN            1            Multi Branched

      ** Get time limit for purge processing from MxPurgeTime system value

     C                   call      'AOSVALR0'                                               AR996631
     C                   parm      *BLANKS       PRetCode                                   AR996631
     C                   parm      PSysVal1      P@OP01                                     AR996631
     C                   parm      *BLANKS       P@VL01                                     AR996631
     C                   parm      *BLANKS       P@OP02                                     AR996631
     C                   parm      *BLANKS       P@VL02                                     AR996631
     C                   parm      *BLANKS       P@OP03                                     AR996631
     C                   parm      *BLANKS       P@VL03                                     AR996631
     C                   parm      *BLANKS       P@OP04                                     AR996631
     C                   parm      *BLANKS       P@VL04                                     AR996631
     C                   parm      *BLANKS       P@OP05                                     AR996631
     C                   parm      *BLANKS       P@VL05                                     AR996631
     C                   parm      *BLANKS       P@OP06                                     AR996631
     C                   parm      *BLANKS       P@VL06                                     AR996631
     C                   parm      *BLANKS       P@OP07                                     AR996631
     C                   parm      *BLANKS       P@VL07                                     AR996631
     C                   parm      *BLANKS       P@OP08                                     AR996631
     C                   parm      *BLANKS       P@VL08                                     AR996631
     C                   parm      *BLANKS       P@OP09                                     AR996631
     C                   parm      *BLANKS       P@VL09                                     AR996631
     C                   parm      *BLANKS       P@OP10                                     AR996631
     C                   parm      *BLANKS       P@VL10
      *
     C                   if        PRetCode <> *BLANKS
     C     *LOCK         in        LDA
     C                   eval      DBFile = 'SDSVALPD'
     C                   eval      DBKEy = P@OP01
     C                   eval      DBase = 4
     C                   out       LDA
     C                   exsr      SRERR
     C                   else
     C                   eval      alpurg = %dec(P@VL01:3:0)
     C                   endif

      ** Determine end time for processing the purge.

      ** Store system date

     C                   z-add     UDATE         TLDATE

      ** Convert current time into minutes, add on time limit and reset
      ** to hours and minutes.

     C                   time                    TLTIME
      *
     C     TLTHH         mult      60            TLMINS            5 0
     C                   add       TLTMM         TLMINS
     C                   add       alpurg        TLMINS
      *
     C     TLMINS        div       60            TLTHH
     C                   mvr                     TLTMM

      ** If over 24 hours, subtract 24 from the total hours and
      ** increment day no. by 1.

     C     TLTHH         ifgt      24
     C                   sub       24            TLTHH

      ** Set date in DDMMYY format for conversion

     C                   z-add     TLDDD         CNDD
     C                   z-add     TLDMM         CNMM
     C                   z-add     TLDYY         CNYY
      *
     C                   move      cndate        ZDATE
     C                   move      '0'           *in98
     C                   exsr      ZDATE1
      *
     C                   z-add     ZDAYNO        w@date
     C                   add       1             w@date

      ** Convert Midas Day no. to system date

     C                   z-add     w@date        ZDAYNO
     C                   move      '0'           *in98
     C                   exsr      ZDATE2
     C                   z-add     ZDATE         w@date
     C                   move      w@date        cndate

      ** Set date in YYMMDD format for compare

     C                   z-add     CNDD          TLDDD
     C                   z-add     CNMM          TLDMM
     C                   z-add     CNYY          TLDYY
      *
     C                   end

      ** Indicate that set up is complete

     C                   seton                                        50

      ** Unwind subroutine stack name

     C                   clear                   @STK(Q)
     C                   sub       1             Q
      *
     C                   endsr
      /EJECT

      ** /Copy point for Date Calculations

      /COPY ZSRSRC,ZDATE1Z2LE
      /COPY ZSRSRC,ZDATE2Z2LE
      /EJECT

      **  File and Program Error Processing

      /COPY MECPYSRC,SRERRCLE
      /EJECT

      ** /Copy point for Arrays

      /COPY ZSRSRC,ZDATE2Z3
**  cpy@ table
(c) Finastra International Limited 2021
