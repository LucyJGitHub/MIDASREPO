     H DEBUG
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas XX Kondor Trigger Program for SDCUSTPD')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX008001 - Trigger program for SDCUSTPD                      *
      *                                                               *
      *  Function:  This program applies an insert and amend trigger  *
      *             to PF/SDCUSTPD.                                   *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (C) Finastra International Banking Systems Ltd. 2023         *
      *                                                               *
      *  Last Amend No. DRI008  *Create    Date 13Jun23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DRI008 - Midas-Kondor Interface Customer Details             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      *  SRINIT - Initial Processing.                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   LR  - Last Record Indicator                                 *
      *                                                               *
      *****************************************************************
      *
     FSDCRWCL1  IF   E           K DISK    INFSR(*PSSR)

     FXXMQCUTD  O    E             Disk    InfSR(*PSSR)
     F                                     Commit
      *
     D ARR@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D QPARM1          DS          8000
      ** Physical file name/library/member
      *
     D  QFNAME                 1     10
     D  QLNAME                11     20
     D  QMNAME                21     30
      ** Trigger Event ('1'=Insert, '2'=Update)
     D  QEVENT                31     31
      ** Trigger Time ('1'=After, '2'=Before)
     D  QTTIME                32     32
      ** Commit Lock Level ('0'=*NONE, '1'=*CHG, '2'=*CS, '3'=*ALL)
     D  QCOMIT                33     33
      ** CCSID
     D  QCCSID                37     40B 0
      ** Offset to original record
     D  Q1ROFF                49     52B 0
      ** Length of the original record
     D  Q1RLEN                53     56B 0
      ** Offset to original record null byte map
     D  Q1NOFF                57     60B 0
      ** Length of the original null byte map
     D  Q1NLEN                61     64B 0
      ** Offset to new record
     D  Q2ROFF                65     68B 0
      ** Length of new record
     D  Q2RLEN                69     72B 0
      ** Offset to the new record null byte map
     D  Q2NOFF                73     76B 0
      ** Length of null byte map
     D  Q2NLEN                77     80B 0
      *
     D QPARM2          DS
     D  QLENG                  1      4B 0
     D QFILEB          DS          4000
     D  BBCUSTB                1      6
     D  BBCNA1B               17     51
     D  BBCNA2B               52     86
     D  BBCNA3B               87    121
     D  BBCRTNB              157    166
     D  BBCRNMB              168    187
     D  BBCNCZB              200    201
     D  BBCOLCB              202    203
     D  BBLINCB              228    229
     D  BBCSIDB              252    263
     D  BBRWCDB              373    376
      ** "Before image of file"
     D QFILEA          DS          4000
      ** "After image of file"
     D  BBCUSTA                1      6
     D  BBCNA1A               17     51
     D  BBCNA2A               52     86
     D  BBCNA3A               87    121
     D  BBCRTNA              157    166
     D  BBCRNMA              168    187
     D  BBCNCZA              200    201
     D  BBCOLCA              202    203
     D  BBLINCA              228    229
     D  BBCSIDA              252    263
     D  BBRWCDA              373    376
      *
     DUREF_DS          DS
      * Data structure for unique reference
     D DATE_YY                 1      4
     D DATE_MM                 5      6
     D DATE_DD                 7      8
     D DATE_HH                 9     10
     D DATE_MN                11     12
     D DATE_SS                13     14
     D UREF_CT                15     15
     D UREF_SQ                16     21

     D PSDS           SDS
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      *
      *
     D DSSDY         E DS                  ExtName(DSSDY)
      ** Second DS For Access Programs, Long Data Structure
      *
     D DSFDY         E DS                  ExtName(DSFDY)
      ** First DS For Access Programs, Short Data Structure

     D SDBANK        E DS                  ExtName(SDBANKPD)
      ** Bank Details

     D SDCTRY        E DS                  ExtName(SDCTRYPD)
      ** Country Details

     D CustMsg       E DS                  ExtName(XXCUSTTD)
      ** Customer MQ message layout file

     D XXCUSD        E DS                  EXTNAME(XXCUSDA)
      ** Data area for Customer unique ref

     D Tmst            S               Z
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            MAIN     - Control Processing.                     *
      *                                                               *
      * CALLS      SRINIT   - Initial processing.                     *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      **  Initial processing
     C                   EXSR      SRINIT
      *
      ** If a record is added or selected fields are updated, prepare extract message.
      *
     C                   Move      *Blanks       Extract           1
     C     QEVENT        Ifeq      '1'
     C                   Move      'Y'           Extract
     C                   Endif
      *
     C     QEVENT        Ifeq      '3'
     C     BBCRNMA       Ifne      BBCRNMB
     C     BBCRTNA       orne      BBCRTNB
     C     BBLINCA       orne      BBLINCB
     C     BBCOLCA       orne      BBCOLCB
     C     BBCNCZA       orne      BBCNCZB
     C     BBCNA1A       orne      BBCNA1B
     C     BBCNA2A       orne      BBCNA2B
     C     BBCNA3A       orne      BBCNA3B
     C     BBRWCDA       orne      BBRWCDB
     C     BBCSIDA       orne      BBCSIDB
     C                   Move      'Y'           Extract
     C                   Endif
     C                   Endif
      *
     C     Extract       Ifeq      'Y'

     C                   Clear                   CustMsg
     C                   ExSR      SRCustExt
     C                   Eval      XMQTRN = CustMsg
      *
      * Prepare remaining fields for XXMQCUTD
     C                   Eval      XMCUST = BBCUSTA
     C                   Eval      XRDNB = BJRDNB
     C                   Eval      XSNTST = ' '
      * Generate a timestamp for this transaction
     C                   Callb     'ZAGENTMSTM'
     C                   Parm                    TmSt
     C                   Eval      XTMSTP = TmSt
      * Unique reference
     C                   EvalR     Date_YY = '0000' + %Char(%subdt(TMST:*years))
     C                   EvalR     Date_MM = '00' + %Char(%subdt(TMST:*months))
     C                   EvalR     Date_DD = '00' + %Char(%subdt(TMST:*days))
     C                   EvalR     Date_HH = '00' + %Char(%subdt(TMST:*hours))
     C                   EvalR     Date_MN = '00' + %Char(%subdt(TMST:*minutes))
     C                   EvalR     Date_SS = '00' + %Char(%subdt(TMST:*seconds))
     C     QEVENT        Ifeq      '1'
     C                   EvalR     Uref_ct = 'I'
     C                   else
     C                   EvalR     Uref_ct = 'A'
     C                   Endif
      *
     C     *LOCK         IN        XXCUSD
     C                   Z-ADD     XXURF         @Uref             6 0
     C                   Add       1             XXURF
     C                   Out       XXCUSD

     C                   Move      @Uref         Uref_Sq
     C                   Eval      XUREF = UREF_DS
      *
      ***  Write Output file
     C                   Write     XXMQCUD0
     C                   Endif
      *
      **   Exit from program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      /Title SR/SRCustExt
      *****************************************************************
      *                                                               *
      *  SRCustExt - Customer message creation.                       *
      *                                                               *
      *  Called By: PROCES                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRCustExt     BegSR
      *
     C                   Eval      XCUST = BBCUSTA
     C                   Eval      XNAME = BBCRNMA + '-' + BBCRTNA
     C                   Eval      XLINC = BBLINCA
      *
     C     BBRWCDA       Chain     SDCRWCL1                           80
     C     *IN80         Ifeq      *Off
     C                   Eval      XTYPE = D5RWDS
     C                   else
     C                   Eval      XTYPE = 'Other'
     C                   Endif
      *
     C                   Eval      XSTAT = 'Full Branch'
     C                   Eval      XRELA = 'None'
      *
     C     BBCOLCA       Ifeq      BJCNCD
     C                   Eval      XRESI = 'Y'
     C                   else
     C                   Eval      XRESI = 'N'
     C                   Endif
      *
     C                   Eval      XREPL = 'Y'
      *
     C                   Eval      XCRTN = *BLanks
      *
     C                   Call      'AOCTRYR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      BBCNCZA       @CNCD             2
     C     SDCTRY        Parm      SDCTRY        DSFDY
     C*
     C     @RTCD         Ifeq      *Blanks
     C     A4ISOC        andne     *Blanks
     C                   Eval      XCNCZ = A4ISOC
     C                   else
     C                   Eval      XCNCZ = BBCNCZA
     C                   Endif
      *
     C                   Eval      XNADD = %TRIM(BBCNA1A) + '  ' +
     C                                     %TRIM(BBCNA2A) + '  ' +
     C                                     %TRIM(BBCNA3A)
      *
     C                   Eval      XRSKS = 'A (refers to N/A)'
      *
     C                   Eval      XCSID = BBCSIDA
      *
     C                   Endsr
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *            SRINIT - Initial Processing                        *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  MAIN   - Control Process                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR                                                  ** SRINIT **
      *
      ** Trigger Program parameters
     C     *ENTRY        PLIST
     C                   PARM                    QPARM1
     C                   PARM                    QPARM2
      *
      *  Data area for Unique reference.
     C     *DTAARA       Define    XXCUSDA       XXCUSD
      *
      ** Set up copyright parameter
     C                   MOVEA     ARR@          CPY2@            80
      *
      ** Using offsets and lengths provided get the before and after
      ** images
     C     Q1ROFF        ADD       1             Q                 5 0
     C     Q1RLEN        SUBST     QPARM1:Q      QFILEB
     C     Q2ROFF        ADD       1             Q
     C     Q2RLEN        SUBST     QPARM1:Q      QFILEA
      *
      ** Access Bank Details
     C                   Call      'AOBANKR0'
     C                   Parm      '*MSG   '     WRTCD             7
     C                   Parm      '*FIRST '     WOPTN             7
     C     SDBANK        Parm      SDBANK        DSSDY
      *
     C     WRTCD         IfNE      *BLANKS
     C                   Z-Add     001           DBASE                          ***************
     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
     C                   Move      *Blanks       DBKEY                          ***************
     C                   ExSR      *PSSR
     C                   Endif

     C                   ENDSR
      *****************************************************************
      /Title SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BegSR                                                  *** *PSSR  ***
      *
      ***  Check to see that *PSSR has not already been called.
     C                   If        WRUN = *BLANK
     C                   Move      'Y'           WRUN              1
     C                   MoveL     'XX008001'    DBPGM
      *
     C                   SetOn                                        U7U8LR
      *
     C                   Dump
     C                   EndIf
      *
      ** Exit program
     C                   Return
      *
     C                   EndSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** ARR@
(C) Finastra International Systems Ltd. 2023
