000100220214     H DEBUG
000200220214     H DATEDIT (*DMY)
000300220214     H COPYRIGHT('(c) Finastra International Limited 2021')
000400220214      *****************************************************************
000500220214/*STD *  RPGBASEBND                                                   *
000600220214/*EXI *  ALWNULL(*USRCTL)                                             *
000700220214/*EXI *  TEXT('Midas ME Purge Incoming MX Msgs - phase 2/2')          *
000800220214      *****************************************************************
000900220214      *                                                               *
001000220214      *  Midas - Message Management Module                            *
001100220214      *                                                               *
001200220214      *  ME2220 - Purge Incoming MX Transactions - Phase 2 of 2       *
001300220214      *                                                               *
001400220214      *  Function:  This program runs for a pre-defined amount of     *
001500220214      *  time and deletes all the I.M.M transactions that may be      *
001600220214      *  purged from the IMM files.                                   *
001700220214      *                                                               *
001800220214      *  Called By: MEC2230 - Incoming MX Message Purge Phase 2 of 2  *
001900220214      *                                                               *
002000220214      *  (c) Finastra International Limited 2021                      *
002100220214      *                                                               *
002200220214      *  Last Amend No. CSW122  *CREATE    Date 04Oct21               *
002300220214      *                                                               *
002400220214      *---------------------------------------------------------------*
002500220214      *                                                               *
002600220214      *  CSW122 - SWIFT ISO20022 Changes                              *
002700220214      *                                                               *
002800220214      *****************************************************************
002900220214      *  Indicator usage                                              *
003000220214      *  ~~~~~~~~~~~~~~~                                              *
003100220214      *                                                               *
003200220214      *  10    Incoming MX Index file EOF indicator                   *
003300220214      *  20    Incoming MX Header file EOF indicator                  *
003400220214      *  30    ME Main details file EOF indicator                     *
003500220214      *  40    ME Element details EOF indicator                       *
003600220214      *  50    First cycle                                            *
003700220214      *  90    Purge file EOF indicator                               *
003800220214      *                                                               *
003900220214      *  LR    End program                                            *
004000220214      *                                                               *
004100220214      *****************************************************************
004200220214      /EJECT
004300220214
004400220214      ** Incoming MX Message Purge File
004500220214
004600220214     FMEMXINRMPDUF   E           K DISK    infsr(srfile)
004700220214     F                                     usropn
004800220214     F                                     commit
004900220214
005000220214      ** MX Message Header file
005100220214
005200220214     FMSMXISOL1 UF   E           K DISK    infsr(srfile)
005300220214     F                                     usropn
005400220214     F                                     commit
005500220214
005600220214      ** MX Message Index file
005700220214
005800220214     FMSIXISOL2 UF   E           K DISK    infsr(srfile)
005900220214     F                                     usropn
006000220214     F                                     commit
006100220214
006200220214      ** ME MX Header file
006300220214
006400220214     FMEISOML1  UF   E           K DISK    infsr(srfile)
006500220214     F                                     usropn
006600220214     F                                     commit
006700220214
006800220214      ** ME MX Details file
006900220214
007000220214     FMEISODL2  UF   E           K DISK    infsr(srfile)
007100220214     F                                     usropn
007200220214     F                                     commit
007300220214      /EJECT
007400220214
007500220214      **  /Copy point for Array Declarations
007600220214
007700220214      /COPY ZSRSRC,ZDATE2Z1LE
007800220214
007900220214      ** /Copy point for error processing declarations
008000220214
008100220214      /COPY MECPYSRC,SRERRELE
008200220214      /COPY MECPYSRC,SRERRILE
008300220214      /EJECT
008400220214
008500220214      ** Array containing Copyright statement
008600220214
008700220214     D cpy@            S             80    dim(1) ctdata perrcd(1)
008800220214
008900220214      ** Working field for message id
009000220214
009100220214     D w@msgid         S             20A
009200220214
009300220214      ** Working field for date conversion
009400220214
009500220214     D w@date          S              5S 0
009600220214
009700220214      ** Fields for getting system value
009800220214
009900220214     D PSysVal1        C                   const('MxPurgeTime')
010000220214     D PRetCode        S              7A
010100220214     D P@OP01          S             20A
010200220214     D P@VL01          S            200A
010300220214     D P@OP02          S             20A
010400220214     D P@VL02          S            200A
010500220214     D P@OP03          S             20A
010600220214     D P@VL03          S            200A
010700220214     D P@OP04          S             20A
010800220214     D P@VL04          S            200A
010900220214     D P@OP05          S             20A
011000220214     D P@VL05          S            200A
011100220214     D P@OP06          S             20A
011200220214     D P@VL06          S            200A
011300220214     D P@OP07          S             20A
011400220214     D P@VL07          S            200A
011500220214     D P@OP08          S             20A
011600220214     D P@VL08          S            200A
011700220214     D P@OP09          S             20A
011800220214     D P@VL09          S            200A
011900220214     D P@OP10          S             20A
012000220214     D P@VL10          S            200A
012100220214     D alpurg          S              3S 0
012200220214
012300220214      ** RUNDAT data area
012400220214
012500220214     D RUNDTA        E DS                  extname(RUNDAT)
012600220214
012700220214      ** Data structure for time/date comparison - time limit
012800220214
012900220214     D dstl            DS
013000220214     D  tldate                 1      6  0
013100220214     D  tlddd                  1      2  0
013200220214     D  tldmm                  3      4  0
013300220214     D  tldyy                  5      6  0
013400220214      *
013500220214     D  tltime                 7     12  0
013600220214     D  tlthh                  7      8  0
013700220214     D  tltmm                  9     10  0
013800220214     D  tltss                 11     12  0
013900220214
014000220214      ** Data structure for time/date comparison - current
014100220214
014200220214     D dscu            DS
014300220214     D  cudate                 1      6  0
014400220214     D  cudyy                  1      2  0
014500220214     D  cudmm                  3      4  0
014600220214     D  cuddd                  5      6  0
014700220214      *
014800220214     D  cutime                 7     12  0
014900220214     D  cuthh                  7      8  0
015000220214     D  cutmm                  9     10  0
015100220214     D  cutss                 11     12  0
015200220214
015300220214      ** Data structure for data conversion to Midas day no.
015400220214
015500220214     D dscn            DS
015600220214     D  cndate                 1      6
015700220214     D  cndd                   1      2  0
015800220214     D  cnmm                   3      4  0
015900220214     D  cnyy                   5      6  0
016000220214      /EJECT
016100220214
016200220214      *****************************************************************
016300220214      *  Index to Subroutines                                         *
016400220214      *                                                               *
016500220214      *  sr_init       : Initialise program                           *
016600220214      *  sr_purge      : Check for purgeable messages                 *
016700220214      *  srerr         : Error processing (on copysource)             *
016800220214      *  zdate1        : Date conversion (on copysource)              *
016900220214      *                                                               *
017000220214      *****************************************************************
017100220214
017200220214      ** Set up copyright statement
017300220214
017400220214     C                   movea     cpy@          bis@             80
017500220214
017600220214      **  Set up subroutine stack name
017700220214
017800220214     C                   add       1             Q
017900220214     C                   movel     'main'        @STK(Q)
018000220214
018100220214      ** Define entry parameters
018200220214
018300220214     C     *entry        plist
018400220214     C                   parm                    w0rtn             7
018500220214
018600220214      ** Initialise program
018700220214
018800220214     C     *in50         ifeq      '0'
018900220214     C                   exsr      sr_init
019000220214     C                   end
019100220214
019200220214      ** Read all message references that are to be purged
019300220214
019400220214     C                   exsr      sr_read
019500220214
019600220214      ** Unwind subroutine stack name
019700220214
019800220214     C                   clear                   @STK(Q)
019900220214     C                   sub       1             Q
020000220214      *
020100220214     C                   seton                                        LR
020200220214      /EJECT
020300220214
020400220214      *****************************************************************
020500220214      *                                                               *
020600220214      *  sr_read  : Read all message references that are to be purged *
020700220214      *                                                               *
020800220214      *  CALLED BY: mainline                                          *
020900220214      *                                                               *
021000220214      *  CALLS    :         -                                         *
021100220214      *                                                               *
021200220214      *****************************************************************
021300220214
021400220214     C     sr_read       begsr
021500220214
021600220214      ** Set up subroutine stack name
021700220214
021800220214     C                   add       1             Q
021900220214     C                   movel     'sr_read'     @STK(Q)
022000220214
022100220214      ** Set limits to read all records
022200220214
022300220214     C                   read      MEMXINRMPD                             90
022400220214
022500220214      ** Read all records until end of time limit.
022600220214      ** The time limit is stored in the MEDTA data structure
022700220214
022800220214     C     *in90         doweq     '0'
022900220214
023000220214      ** Move Message Id to working field for use on short message id fields
023100220214
023200220214     C                   eval      w@msgid = %trim(RMMXID)
023300220214
023400220214      ** Purge all associated records for the message reference
023500220214
023600220214     C                   exsr      sr_purge
023700220214
023800220214      ** Delete Purge File record and commit all deletes
023900220214
024000220214     C                   delete    @INRMPD
024100220214     C                   commit
024200220214
024300220214      *  Update current time and date. UDATE is set in Header spec to
024400220214      *  be in the format DDMMYY.
024500220214      *
024600220214     C                   time                    cudttm           12 0
024700220214     C                   time                    cutime
024800220214     C                   z-add     cudttm        cudate
024900220214
025000220214      ** Check if processing is still within the time limit.
025100220214      ** If not leave the processing after setting return code to send
025200220214      ** a message to Audit Log on MRUNQ.
025300220214
025400220214     C     dscu          ifge      dstl
025500220214     C                   movel     'MIN0098'     w0rtn
025600220214     C                   leave
025700220214     C                   end
025800220214
025900220214      ** Read next record
026000220214
026100220214     C                   read      MEMXINRMPD                             90
026200220214      *
026300220214     C                   enddo
026400220214
026500220214      ** Unwind subroutine stack name
026600220214
026700220214     C                   clear                   @STK(Q)
026800220214     C                   sub       1             Q
026900220214      *
027000220214     C                   endsr
027100220214      /EJECT
027200220214
027300220214      *****************************************************************
027400220214      *                                                               *
027500220214      *  sr_purge : Purge all records with the corresponding message  *
027600220214      *           : reference from the purge logs                     *
027700220214      *                                                               *
027800220214      *  CALLED BY: sr_read                                           *
027900220214      *                                                               *
028000220214      *  CALLS    : sr_mxindx                                         *
028100220214      *           : sr_mxhdr                                          *
028200220214      *           : sr_memain                                         *
028300220214      *           : sr_medtls                                         *
028400220214      *                                                               *
028500220214      *****************************************************************
028600220214
028700220214     C     sr_purge      begsr
028800220214
028900220214      ** Set up subroutine stack name
029000220214
029100220214     C                   add       1             Q
029200220214     C                   movel     'sr_purge'    @STK(Q)
029300220214
029400220214      ** Read and purge records from MX Messages Index file
029500220214
029600220214     C                   exsr      sr_mxindx
029700220214
029800220214      ** Read and purge records from MX Messages Header file
029900220214
030000220214     C                   exsr      sr_mxhdr
030100220214
030200220214      ** Read and purge records from ME Main details file
030300220214
030400220214     C                   exsr      sr_memain
030500220214
030600220214      ** Read and purge records from ME Element details file
030700220214
030800220214     C                   exsr      sr_medtls
030900220214
031000220214      ** Unwind subroutine stack name
031100220214
031200220214     C                   clear                   @STK(Q)
031300220214     C                   sub       1             Q
031400220214      *
031500220214     C                   endsr
031600220214      /EJECT
031700220214
031800220214      *****************************************************************
031900220214      *                                                               *
032000220214      *  sr_mxindx:                                                   *
032100220214      *                                                               *
032200220214      *  CALLED BY: sr_purge                                          *
032300220214      *                                                               *
032400220214      *  CALLS    :                                                   *
032500220214      *                                                               *
032600220214      *****************************************************************
032700220214
032800220214     C     sr_mxindx     begsr
032900220214
033000220214      ** Set up subroutine stack name
033100220214
033200220214     C                   add       1             Q
033300220214     C                   movel     'sr_mxindx'   @STK(Q)
033400220214
033500220214      ** Read the MX Index file
033600220214
033700220214     C     KYMSIX        klist
033800220214     C                   kfld                    RMMXID
033900220214     C                   kfld                    RMUETR
034000220214
034100220214     C     KYMSIX        setll     MSIXISOL2
034200220214     C     KYMSIX        reade     MSIXISOL2                              10
034300220214
034400220214      ** If record found proceed with the purge process
034500220214
034600220214     C     *in10         ifeq      '0'
034700220214     C                   delete    MSIXISD0
034800220214     C                   endif
034900220214
035000220214      ** Unwind subroutine stack name
035100220214
035200220214     C                   clear                   @STK(Q)
035300220214     C                   sub       1             Q
035400220214      *
035500220214     C                   endsr
035600220214      /EJECT
035700220214
035800220214      *****************************************************************
035900220214      *                                                               *
036000220214      *  sr_mxhdr :                                                   *
036100220214      *                                                               *
036200220214      *  CALLED BY: sr_purge                                          *
036300220214      *                                                               *
036400220214      *  CALLS    :                                                   *
036500220214      *                                                               *
036600220214      *****************************************************************
036700220214
036800220214     C     sr_mxhdr      begsr
036900220214
037000220214      ** Set up subroutine stack name
037100220214
037200220214     C                   add       1             Q
037300220214     C                   movel     'sr_mxhdr'    @STK(Q)
037400220214
037500220214      ** Read the MX Header file
037600220214
037700220214     C     KYMSMX        klist
037800220214     C                   kfld                    RMMXID
037900220214     C                   kfld                    RMUETR
038000220214      *
038100220214     C     KYMSMX        setll     MSMXISOL1
038200220214     C     KYMSMX        reade     MSMXISOL1                              20
038300220214
038400220214      ** Read file until the key changes
038500220214
038600220214     C     *in20         doweq     '0'
038700220214
038800220214      ** Delete the corresponding record and read the file again for another record
038900220214     C                   delete    MSMXISD0
039000220214      *
039100220214     C     KYMSMX        setll     MSMXISOL1
039200220214     C     KYMSMX        reade     MSMXISOL1                              20
039300220214      *
039400220214     C                   enddo
039500220214
039600220214      ** Unwind subroutine stack name
039700220214
039800220214     C                   clear                   @STK(Q)
039900220214     C                   sub       1             Q
040000220214      *
040100220214     C                   endsr
040200220214      /EJECT
040300220214
040400220214      *****************************************************************
040500220214      *                                                               *
040600220214      *  sr_memain:                                                   *
040700220214      *                                                               *
040800220214      *  CALLED BY: sr_purge                                          *
040900220214      *                                                               *
041000220214      *  CALLS    :                                                   *
041100220214      *                                                               *
041200220214      *****************************************************************
041300220214
041400220214     C     sr_memain     begsr
041500220214
041600220214      ** Set up subroutine stack name
041700220214
041800220214     C                   add       1             Q
041900220214     C                   movel     'sr_mxindx'   @STK(Q)
042000220214
042100220214      ** Read the MX Element header file
042200220214
042300220214     C     KYMEMD        klist
042400220214     C                   kfld                    w@msgid
042500220214     C                   kfld                    RMUETR
042600220214      *
042700220214     C     KYMEMD        setll     MEISOML1
042800220214     C     KYMEMD        reade     MEISOML1                               30
042900220214
043000220214      ** If record is found, proceed with the purge process
043100220214
043200220214     C     *in30         ifeq      '0'
043300220214
043400220214      ** Delete the record if found
043500220214
043600220214     C                   delete    MEISOMD0
043700220214      *
043800220214     C                   endif
043900220214
044000220214      ** Unwind subroutine stack name
044100220214
044200220214     C                   clear                   @STK(Q)
044300220214     C                   sub       1             Q
044400220214      *
044500220214     C                   endsr
044600220214      /EJECT
044700220214
044800220214      *****************************************************************
044900220214      *                                                               *
045000220214      *  sr_medtls:                                                   *
045100220214      *                                                               *
045200220214      *  CALLED BY: sr_purge                                          *
045300220214      *                                                               *
045400220214      *  CALLS    :                                                   *
045500220214      *                                                               *
045600220214      *****************************************************************
045700220214
045800220214     C     sr_medtls     begsr
045900220214
046000220214      ** Set up subroutine stack name
046100220214
046200220214     C                   add       1             Q
046300220214     C                   movel     'sr_mxindx'   @STK(Q)
046400220214
046500220214      ** Read the MX Element details file
046600220214
046700220214     C     KYMEED        klist
046800220214     C                   kfld                    w@msgid
046900220214     C                   kfld                    RMUETR
047000220214      *
047100220214     C     KYMEED        setll     MEISODL2
047200220214     C     KYMEED        reade     MEISODL2                               40
047300220214
047400220214      ** Read until end of file
047500220214
047600220214     C     *in40         doweq     '0'
047700220214
047800220214      ** Delete record from file then read the file again
047900220214
048000220214     C                   delete    MEISODD0
048100220214      *
048200220214     C     KYMEED        setll     MEISODL2
048300220214     C     KYMEED        reade     MEISODL2                               40
048400220214      *
048500220214     C                   enddo
048600220214      ** Unwind subroutine stack name
048700220214
048800220214     C                   clear                   @STK(Q)
048900220214     C                   sub       1             Q
049000220214      *
049100220214     C                   endsr
049200220214      /EJECT
049300220214
049400220214      *****************************************************************
049500220214      *                                                               *
049600220214      *  sr_init  : Initialise and define fields                      *
049700220214      *                                                               *
049800220214      *  CALLED BY: mainline                                          *
049900220214      *                                                               *
050000220214      *  CALLS    : srerr  - Error Processing                         *
050100220214      *                                                               *
050200220214      *****************************************************************
050300220214
050400220214     C     sr_init       begsr
050500220214
050600220214      **  Set up subroutine stack name
050700220214
050800220214     C                   add       1             Q                 5 0
050900220214     C                   movel     'sr_init'     @STK(Q)
051000220214
051100220214      ** Open Files
051200220214
051300220214     C                   open      MEMXINRMPD
051400220214     C                   open      MSMXISOL1
051500220214     C                   open      MSIXISOL2
051600220214     C                   open      MEISOML1
051700220214     C                   open      MEISODL2
051800220214
051900220214      ** Get Rundate information
052000220214
052100220214     C     *DTAARA       define    RUNDAT        RUNDTA
052200220214     C                   in        RUNDTA
052300220214     C                   move      AGMRDT        WUMRDT            7            Midas Run date
052400220214     C                   move      AGRDNB        WURDNB            5 0          Run day number
052500220214     C                   move      AGSUC         WUSUC             1            Set up complete
052600220214     C                   move      AGDFF         WUDFF             1            Date Format
052700220214     C                   move      AGMBIN        WUMBIN            1            Multi Branched
052800220214
052900220214      ** Get time limit for purge processing from MxPurgeTime system value
053000220214
053100220214     C                   call      'AOSVALR0'                                               AR996631
053200220214     C                   parm      *BLANKS       PRetCode                                   AR996631
053300220214     C                   parm      PSysVal1      P@OP01                                     AR996631
053400220214     C                   parm      *BLANKS       P@VL01                                     AR996631
053500220214     C                   parm      *BLANKS       P@OP02                                     AR996631
053600220214     C                   parm      *BLANKS       P@VL02                                     AR996631
053700220214     C                   parm      *BLANKS       P@OP03                                     AR996631
053800220214     C                   parm      *BLANKS       P@VL03                                     AR996631
053900220214     C                   parm      *BLANKS       P@OP04                                     AR996631
054000220214     C                   parm      *BLANKS       P@VL04                                     AR996631
054100220214     C                   parm      *BLANKS       P@OP05                                     AR996631
054200220214     C                   parm      *BLANKS       P@VL05                                     AR996631
054300220214     C                   parm      *BLANKS       P@OP06                                     AR996631
054400220214     C                   parm      *BLANKS       P@VL06                                     AR996631
054500220214     C                   parm      *BLANKS       P@OP07                                     AR996631
054600220214     C                   parm      *BLANKS       P@VL07                                     AR996631
054700220214     C                   parm      *BLANKS       P@OP08                                     AR996631
054800220214     C                   parm      *BLANKS       P@VL08                                     AR996631
054900220214     C                   parm      *BLANKS       P@OP09                                     AR996631
055000220214     C                   parm      *BLANKS       P@VL09                                     AR996631
055100220214     C                   parm      *BLANKS       P@OP10                                     AR996631
055200220214     C                   parm      *BLANKS       P@VL10
055300220214      *
055400220214     C                   if        PRetCode <> *BLANKS
055500220214     C     *LOCK         in        LDA
055600220214     C                   eval      DBFile = 'SDSVALPD'
055700220214     C                   eval      DBKEy = P@OP01
055800220214     C                   eval      DBase = 4
055900220214     C                   out       LDA
056000220214     C                   exsr      SRERR
056100220214     C                   else
056200220214     C                   eval      alpurg = %dec(P@VL01:3:0)
056300220214     C                   endif
056400220214
056500220214      ** Determine end time for processing the purge.
056600220214
056700220214      ** Store system date
056800220214
056900220214     C                   z-add     UDATE         TLDATE
057000220214
057100220214      ** Convert current time into minutes, add on time limit and reset
057200220214      ** to hours and minutes.
057300220214
057400220214     C                   time                    TLTIME
057500220214      *
057600220214     C     TLTHH         mult      60            TLMINS            5 0
057700220214     C                   add       TLTMM         TLMINS
057800220214     C                   add       alpurg        TLMINS
057900220214      *
058000220214     C     TLMINS        div       60            TLTHH
058100220214     C                   mvr                     TLTMM
058200220214
058300220214      ** If over 24 hours, subtract 24 from the total hours and
058400220214      ** increment day no. by 1.
058500220214
058600220214     C     TLTHH         ifgt      24
058700220214     C                   sub       24            TLTHH
058800220214
058900220214      ** Set date in DDMMYY format for conversion
059000220214
059100220214     C                   z-add     TLDDD         CNDD
059200220214     C                   z-add     TLDMM         CNMM
059300220214     C                   z-add     TLDYY         CNYY
059400220214      *
059500220214     C                   move      cndate        ZDATE
059600220214     C                   move      '0'           *in98
059700220214     C                   exsr      ZDATE1
059800220214      *
059900220214     C                   z-add     ZDAYNO        w@date
060000220214     C                   add       1             w@date
060100220214
060200220214      ** Convert Midas Day no. to system date
060300220214
060400220214     C                   z-add     w@date        ZDAYNO
060500220214     C                   move      '0'           *in98
060600220214     C                   exsr      ZDATE2
060700220214     C                   z-add     ZDATE         w@date
060800220214     C                   move      w@date        cndate
060900220214
061000220214      ** Set date in YYMMDD format for compare
061100220214
061200220214     C                   z-add     CNDD          TLDDD
061300220214     C                   z-add     CNMM          TLDMM
061400220214     C                   z-add     CNYY          TLDYY
061500220214      *
061600220214     C                   end
061700220214
061800220214      ** Indicate that set up is complete
061900220214
062000220214     C                   seton                                        50
062100220214
062200220214      ** Unwind subroutine stack name
062300220214
062400220214     C                   clear                   @STK(Q)
062500220214     C                   sub       1             Q
062600220214      *
062700220214     C                   endsr
062800220214      /EJECT
062900220214
063000220214      ** /Copy point for Date Calculations
063100220214
063200220214      /COPY ZSRSRC,ZDATE1Z2LE
063300220214      /COPY ZSRSRC,ZDATE2Z2LE
063400220214      /EJECT
063500220214
063600220214      **  File and Program Error Processing
063700220214
063800220214      /COPY MECPYSRC,SRERRCLE
063900220214      /EJECT
064000220214
064100220214      ** /Copy point for Arrays
064200220214
064300220214      /COPY ZSRSRC,ZDATE2Z3
064400220214**  cpy@ table
064500220214(c) Finastra International Limited 2021
