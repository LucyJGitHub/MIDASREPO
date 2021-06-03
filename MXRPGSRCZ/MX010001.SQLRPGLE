     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *          MD056612
/*STD *  RPGSQLMOD                                                    *          MD056612
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056612
/*EXI *  TEXT('Midas MX Initialisation for Midas Message Manager')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
/*    *  MX010001 - MX Initialisation for Midas Message Manager       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD056612           Date 12Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8319            Date 05Sep05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025  *CREATE    Date 18Jun02               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  BUG8319 - Failed COB component after NextDaySetup            *
      *  CSW025 - Midas Message Manager                               *
      *                                                               *
      *****************************************************************
     F*MXCOMDL1* UF   E           K DISK    INFSR(*PSSR)
     F*MXEXFDL2* UF   E           K DISK    INFSR(*PSSR)                                    MD056612
                                                                                            MD056612
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D sdbank        E DS                  extname(SDBANKPD)
     D MXCOMD        E DS                  EXTNAME(MXCMDJW0)                                MD056612
     D MXEXFD        E DS                  EXTNAME(MXEXDJW0)                                MD056612

      ** Bank details ICD
     c     *entry        plist
     c                   parm                    pdtaq            10
     c                   parm                    plib             10
     c                   parm                    prptp             1
     c                   parm                    prtcd             5

     c     key           klist
     c                   kfld                    CDCOMI
     c                   kfld                    CDEXTT

      *  Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     c     pdtaq         ifne      *blank
      *                                                                                      BUG8319
      ** Change DTAQ to KTAQ                                                                 BUG8319
      *                                                                                      BUG8319
     c*****'DTAQ/'       cat(p)    plib:0        queue            48                         BUG8319
     c     'KTAQ/'       cat(p)    plib:0        queue            48                         BUG8319
     c                   cat       '/':0         queue
     c                   cat       pdtaq:0       queue

     c                   movel     'MSG_TRD'     CDCOMI
     c                   movel     'C'           CDEXTT
     c*****key**         chain     mxcomdl1                           10                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXCOMD                                                                        MD056612
     C+ from MXCMDJW0                                                                       MD056612
     C+ where CDCOMI = :CDCOMI and CDEXTT = :CDEXTT                                         MD056612
     C/END-EXEC                                                                             MD056612
     c******in10         ifeq      '0'                                                      MD056612
     c                   if        SQLCODE = 0                                              MD056612
     c                   movel     queue         CDMSGQ
     c                   movel     'D'           CDEXFQ
     c                   movel     BJRDNB        CDEXND
     c                   movel     prptp         CDMTRT
     c**********         update    MXCOMDP0                                                 MD056612
     C/exec SQL                                                                             MD056612
     C+ update MXCMDXTD set                                                                 MD056612
     C+   CDMSGQ = :CDMSGQ,                                                                 MD056612
     C+   CDEXFQ = :CDEXFQ,                                                                 MD056612
     C+   CDEXND = :CDEXND,                                                                 MD056612
     C+   CDMTRT = :CDMTRT                                                                  MD056612
     C+ where CDCOMI = :CDCOMI and CDEXTT = :CDEXTT                                         MD056612
     C/end-exec                                                                             MD056612
     c                   end

     c                   movel     'MSG_DPM'     CDCOMI
     c                   movel     'C'           CDEXTT
     c*****key**         chain     mxcomdl1                           10                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXCOMD                                                                        MD056612
     C+ from MXCMDJW0                                                                       MD056612
     C+ where CDCOMI = :CDCOMI and CDEXTT = :CDEXTT                                         MD056612
     C/END-EXEC                                                                             MD056612
     c******in10         ifeq      '0'                                                      MD056612
     c                   if        SQLCODE = 0                                              MD056612
     c                   movel     queue         CDMSGQ
     c                   movel     'D'           CDEXFQ
     c                   movel     BJRDNB        CDEXND
     c                   movel     prptp         CDMTRT
     c**********         update    MXCOMDP0                                                 MD056612
     C/exec SQL                                                                             MD056612
     C+ update MXCMDXTD set                                                                 MD056612
     C+   CDMSGQ = :CDMSGQ,                                                                 MD056612
     C+   CDEXFQ = :CDEXFQ,                                                                 MD056612
     C+   CDEXND = :CDEXND,                                                                 MD056612
     C+   CDMTRT = :CDMTRT                                                                  MD056612
     C+ where CDCOMI = :CDCOMI and CDEXTT = :CDEXTT                                         MD056612
     C/end-exec                                                                             MD056612
     c                   end

     c                   movel     'MSG_PST'     CDCOMI
     c                   movel     'C'           CDEXTT
     c*****key**         chain     mxcomdl1                           10                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXCOMD                                                                        MD056612
     C+ from MXCMDJW0                                                                       MD056612
     C+ where CDCOMI = :CDCOMI and CDEXTT = :CDEXTT                                         MD056612
     C/END-EXEC                                                                             MD056612
     c******in10         ifeq      '0'                                                      MD056612
     c                   if        SQLCODE = 0                                              MD056612
     c                   movel     queue         CDMSGQ
     c                   movel     'D'           CDEXFQ
     c                   movel     BJRDNB        CDEXND
     c                   movel     prptp         CDMTRT
     c**********         update    MXCOMDP0                                                 MD056612
     C/exec SQL                                                                             MD056612
     C+ update MXCMDXTD set                                                                 MD056612
     C+   CDMSGQ = :CDMSGQ,                                                                 MD056612
     C+   CDEXFQ = :CDEXFQ,                                                                 MD056612
     C+   CDEXND = :CDEXND,                                                                 MD056612
     C+   CDMTRT = :CDMTRT                                                                  MD056612
     C+ where CDCOMI = :CDCOMI and CDEXTT = :CDEXTT                                         MD056612
     C/end-exec                                                                             MD056612
     c                   end

     c                   movel     'MGCURRD0'    EXFMT
     c*****EXFMT         chain     MXEXFDL2                           11                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFMT  = :EXFMT                                                               MD056612
     C/END-EXEC                                                                             MD056612
     c******in11         ifeq      '0'                                                      MD056612
     c     SQLCODE       ifeq      0                                                        MD056612
     c                   movel     queue         EXMSGQ
     c                   movel     'D'           EXEXFQ
     c                   movel     BJRDNB        EXEXND
     c                   movel     prptp         EXMTRT
     c**********         update    MXEXFDP0
     C/exec SQL                                                                             MD056612
     C+ update MXEXDXTD set                                                                 MD056612
     C+   EXMSGQ = :EXMSGQ,                                                                 MD056612
     C+   EXEXFQ = :EXEXFQ,                                                                 MD056612
     C+   EXEXND = :EXEXND,                                                                 MD056612
     C+   EXMTRT = :EXMTRT                                                                  MD056612
     C+ where EXFMT  = :EXFMT                                                               MD056612
     C/end-exec                                                                             MD056612
     c                   end

     c                   movel     'MGBRCHD0'    EXFMT
     c*****EXFMT         chain     MXEXFDL2                           11                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFMT  = :EXFMT                                                               MD056612
     C/END-EXEC                                                                             MD056612
     c******in11         ifeq      '0'                                                      MD056612
     c     SQLCODE       ifeq      0                                                        MD056612
     c                   movel     queue         EXMSGQ
     c                   movel     'D'           EXEXFQ
     c                   movel     BJRDNB        EXEXND
     c                   movel     prptp         EXMTRT
     c**********         update    MXEXFDP0
     C/exec SQL                                                                             MD056612
     C+ update MXEXDXTD set                                                                 MD056612
     C+   EXMSGQ = :EXMSGQ,                                                                 MD056612
     C+   EXEXFQ = :EXEXFQ,                                                                 MD056612
     C+   EXEXND = :EXEXND,                                                                 MD056612
     C+   EXMTRT = :EXMTRT                                                                  MD056612
     C+ where EXFMT  = :EXFMT                                                               MD056612
     C/end-exec                                                                             MD056612
     c                   end

     c                   end

     C                   seton                                        LR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   movel     'ERROR'       prtcd
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
