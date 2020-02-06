     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CSW208 Initialisation Program 2')
      *****************************************************************
      *                                                               *
      *  Midas - MIDAS Common Routines                                *
      *                                                               *
      *  SD001002 - Midas SD CSW208 Initialisation Program 2          *
      *                                                               *
      *  Function:  This module will update the Outgoing Message      *
      *             Field Management file in order to insert 1/ in    *
      *             the second line of the format if required.        *
      *                                                               *
      *  Component of: SDC001002 (Midas SD CSW208 Initialisation      *
      *                           Program 2)                          *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *    10         End of record of MEOUFML1                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SrRcfEnd - Subroutine to write End of report                  *
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
 
     FMEOUFML1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas ME Outgoing Message Field - Retrieval Index
 
     FMEOUFML7  UF   E           K DISK
     F                                     RENAME(@OUFMPD:@OUFMPDX0)
     F                                     Prefix(A_)
      ** Midas ME Outgoing Message Field - Update Index
 
     FSD001002AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
     FSD001002P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
     FSD001002P2O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL2)
 
     FSD001002P3O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL3)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
     D SPOOL3          DS
     D  SFILE3                83     92
     D  SFNUM3               123    124B 0
     D  OFLLN3               188    189B 0
     D  PRTLN3               367    368B 0
 
     D MEOUFDATA       DS
     D  OM50FSS                1      3
     D  OM50F1S                4     18
     D  OM50F2S               19     33
     D  OM50F3S               34     48
     D  OM50F4S               49     63
     D  OM50F5S               64     78
 
     D MEOUFDATA2      DS
     D  TOM50FS                1      3
     D  TOM50F1                4     18
     D  TOM50F2               19     33
     D  TOM50F3               34     48
     D  TOM50F4               49     63
     D  TOM50F5               64     78
      *
     D LDA           E DS           256    EXTNAME(LDA)
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      *
      ** Data Area giving Installation Control Details
      *
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short Data Structure
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D MeoufAr         S                   DIM(9999) LIKE(MeoufData)
     D @RUN            S              1
     D OMNWRKS         S              6
     D OMMTPYS         S              3
     D OMMTAGS         S              5
     D OMSBRCS         S              4
     D OMCTRYS         S              4
     D OMCURRS         S              3
     D OMNOSTS         S              2
     D OMACTIS         S             10
     D OM50FS2         S              3
     D MEOUFDATA3      S             75
     D MEOUFDATA4      S             75
     D NewRec          S              1
     D FirstRec        S              1
     D PPSEQ           S              5
     D PENTY           S                   LIKE(PPSEQ)
     D PSERR           S              1
     D PSNUM1          S              6  0
     D PSNUM2          S                   LIKE(PSNUM1)
     D PSNUM3          S                   LIKE(PSNUM1)
     D PSNUMU          S                   LIKE(PSNUM1)
     D Wopen1          S              1
     D Wopen2          S              1
     D Wopen3          S              1
     D Wdifln          S              3  0
     D Main1           S              1
     D Main2           S              1
     D Main3           S              1
     D @Rtcd           S              7A
     D @Optn           S              7A
     D @Sard           S              6A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     KMEOUF1       KLIST
     C                   KFLD                    OMNWRK
     C                   KFLD                    OMMTPY
     C                   KFLD                    OMMTAG
     C                   KFLD                    OMSBRC
     C                   KFLD                    OMCTRY
     C                   KFLD                    OMCURR
     C                   KFLD                    OMNOST
     C                   KFLD                    OMACTI
      *
     C     KMEOUF7       KLIST
     C                   KFLD                    OMNWRKS
     C                   KFLD                    OMMTPYS
     C                   KFLD                    OMMTAGS
     C                   KFLD                    OMSBRCS
     C                   KFLD                    OMCTRYS
     C                   KFLD                    OMCURRS
     C                   KFLD                    OMNOSTS
     C                   KFLD                    OMACTIS
     C                   KFLD                    OM50FS2
      *
      ** Access MEOUFML1 record
      *
     C     *LOVAL        SETLL     MEOUFML1
     C                   READ      MEOUFML1
      *
      ** Initialise values
      *
     C                   Z-ADD     0             g                 5 0
     C                   Z-ADD     0             h                 5 0
     C                   Z-ADD     0             i                 5 0
     C                   Z-ADD     0             RNumP1
     C                   Z-ADD     0             RNumP2
     C                   Z-ADD     0             RNumP3
     C                   EVAL      Wopen1 = *BLANKS
     C                   EVAL      Wopen2 = *BLANKS
     C                   EVAL      Wopen3 = *BLANKS
     C                   EVAL      NewRec = 'Y'
     C                   EVAL      FirstRec = 'Y'
     C                   DOW       NOT (%EOF(MEOUFML1))
      *
      ** Determine if will access/process next record
      *
     C                   IF        FirstRec = 'N'
     C                   EVAL      *IN10 = *OFF
     C                   READ      MEOUFML1                               10
     C                   ENDIF
     C                   EVAL      FirstRec = 'N'
      *
      ** Collect records with action equal to *Format and
      ** if new record or same details and not end of file of MEOUFML1
      *
     C                   IF        OMACTI = '*FORMAT' and
     C                             OMNWRKS = OMNWRK and
     C                             OMMTPYS = OMMTPY and
     C                             OMMTAGS = OMMTAG and
     C                             OMSBRCS = OMSBRC and
     C                             OMCTRYS = OMCTRY and
     C                             OMCURRS = OMCURR and
     C                             OMNOSTS = OMNOST and
     C                             OMACTIS = OMACTI and
     C                             *IN10 = '0' or
     C                             OMACTI = '*FORMAT' and
     C                             NewRec = 'Y' and
     C                             *IN10 = '0'
     C                   EVAL      NewRec = 'N'
     C                   MOVEL     OM50F2        OM50F2A           2
      *
      ** Check if record can still be change that requires
      ** to be updated
      *
     C                   IF        OM50F5 <> *BLANKS and
     C                             OM50F2A <> '1/'
     C                   IF        Wopen2 <> 'Y'
     C                   EVAL      Wopen2 = 'Y'
     C                   OPEN      SD001002P2
     C                   ENDIF
     C                   IF        RNumP2 <> 0
      *
      ** Check if there is sufficient line to write the details of
      ** the report
      *
     C                   EVAL      WDIFLN = OFLLN2 - PRTLN2
     C                   IF        WDIFLN <= 1
     C                   WRITE     HEADPY2
     C                   ENDIF
     C                   ELSE
     C                   WRITE     HEADPY2
     C                   ENDIF
     C                   EVAL      ROMNWRK2 = OMNWRK
     C                   EVAL      ROMMTPY2 = OMMTPY
     C                   EVAL      ROMMTAG2 = OMMTAG
     C                   EVAL      ROMSBRC2 = OMSBRC
     C                   EVAL      ROMCTRY2 = OMCTRY
     C                   EVAL      ROMCURR2 = OMCURR
     C                   EVAL      ROMNOST2 = OMNOST
     C                   EVAL      ROM50F12 = OM50F1
     C                   EVAL      ROM50F22 = OM50F2
     C                   EVAL      ROM50F32 = OM50F3
     C                   EVAL      ROM50F42 = OM50F4
     C                   EVAL      ROM50F52 = OM50F5
     C                   IF        Main2 <> 'N'
     C                   WRITE     DETAIL2M
     C                   ELSE
     C                   WRITE     DETAIL2
     C                   ENDIF
     C                   EVAL      Main2 = 'N'
     C                   EVAL      RNumP2 = RNumP2 + 1
     C                   ELSE
      *
      ** Store record with same details in the array
      *
     C                   EVAL      i = i + 1
     C                   EVAL      h = h + 1
     C                   EVAL      TOM50FS = OM50FS
     C                   EVAL      TOM50F1 = OM50F1
     C                   EVAL      TOM50F2 = OM50F2
     C                   EVAL      TOM50F3 = OM50F3
     C                   EVAL      TOM50F4 = OM50F4
     C                   EVAL      TOM50F5 = OM50F5
      *
     C                   MOVEA     MEOUFDATA2    MeoufAr(i)
     C                   ENDIF
     C                   ELSE
      *
      ** If array is not empty
      *
     C                   IF        h > 0
     C                   EVAL      i = 1
     C                   EVAL      ROMNWRK1 = OMNWRKS
     C                   EVAL      ROMMTPY1 = OMMTPYS
     C                   EVAL      ROMMTAG1 = OMMTAGS
     C                   EVAL      ROMSBRC1 = OMSBRCS
     C                   EVAL      ROMCTRY1 = OMCTRYS
     C                   EVAL      ROMCURR1 = OMCURRS
     C                   EVAL      ROMNOST1 = OMNOSTS
     C                   EVAL      ROMNWRK3 = OMNWRKS
     C                   EVAL      ROMMTPY3 = OMMTPYS
     C                   EVAL      ROMMTAG3 = OMMTAGS
     C                   EVAL      ROMSBRC3 = OMSBRCS
     C                   EVAL      ROMCTRY3 = OMCTRYS
     C                   EVAL      ROMCURR3 = OMCURRS
     C                   EVAL      ROMNOST3 = OMNOSTS
     C                   DOW       (i <= h)
     C                   MOVEA     MeoufAr(i)    MEOUFDATA2
     C                   MOVEL     TOM50F2       TOM50F2A          2
      *
      ** Update record with correct details
      *
     C                   IF        TOM50F5 = *BLANKS and
     C                             TOM50F2A <> '1/' and
     C                             MeoufAr(i) <> *BLANKS
     C                   EVAL      TOM50F5 = TOM50F4
     C                   EVAL      TOM50F4 = TOM50F3
     C                   EVAL      TOM50F3 = TOM50F2
     C                   MOVEL     '1/'          TOM50F2
     C                   IF        Wopen1 <> 'Y'
     C                   EVAL      Wopen1 = 'Y'
     C                   OPEN      SD001002P1
     C                   ENDIF
     C                   IF        RNumP1 <> 0
      *
      ** Check if there is sufficient line to write the details of
      ** the report
      *
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN <= 1
     C                   WRITE     HEADPY1
     C                   ENDIF
     C                   ELSE
     C                   WRITE     HEADPY1
     C                   ENDIF
     C                   EVAL      ROM50F11 = TOM50F1
     C                   EVAL      ROM50F21 = TOM50F2
     C                   EVAL      ROM50F31 = TOM50F3
     C                   EVAL      ROM50F41 = TOM50F4
     C                   EVAL      ROM50F51 = TOM50F5
     C                   IF        Main1 <> 'N'
     C                   WRITE     DETAIL1M
     C                   ELSE
     C                   WRITE     DETAIL1
     C                   ENDIF
     C                   EVAL      Main1 = 'N'
     C                   EVAL      RNumP1 = RNumP1 + 1
     C                   EVAL      g = 1
      *
      ** Check if it has duplicate details
      *
     C                   DOW       (g <= h)
     C                   MOVE      *BLANKS       MEOUFDATA3
     C                   MOVE      *BLANKS       MEOUFDATA4
     C                   MOVE      MeoufAr(g)    MEOUFDATA3
     C                   MOVEL     MeoufAr(g)    OM50FS2
     C                   MOVE      MEOUFDATA2    MEOUFDATA4
     C                   IF        MeoufAr(g) <> *BLANKS and
     C                             MEOUFDATA3 = MEOUFDATA4
     C                   IF        Wopen3 <> 'Y'
     C                   EVAL      Wopen3 = 'Y'
     C                   OPEN      SD001002P3
     C                   ENDIF
     C                   IF        RNumP3 <> 0
      *
      ** Check if there is sufficient line to write the details of
      ** the report
      *
     C                   EVAL      WDIFLN = OFLLN3 - PRTLN3
     C                   IF        WDIFLN <= 1
     C                   WRITE     HEADPY3
     C                   ENDIF
     C                   ELSE
     C                   WRITE     HEADPY3
     C                   ENDIF
     C                   EVAL      ROM50F13 = TOM50F1
     C                   EVAL      ROM50F23 = TOM50F2
     C                   EVAL      ROM50F33 = TOM50F3
     C                   EVAL      ROM50F43 = TOM50F4
     C                   EVAL      ROM50F53 = TOM50F5
     C                   IF        Main3 <> 'N'
     C                   WRITE     DETAIL3M
     C                   ELSE
     C                   WRITE     DETAIL3
     C                   ENDIF
     C                   EVAL      Main3 = 'N'
     C                   EVAL      RNumP3 = RNumP3 + 1
      *
      ** Delete record both in array and MEOUFMPD file
      *
     C                   MOVE      *BLANKS       MeoufAr(g)
     C     KMEOUF7       CHAIN     MEOUFML7
     C                   IF        %FOUND(MEOUFML7)
     C                   DELETE    @OUFMPDX0
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      g = g + 1
     C                   ENDDO
     C                   ENDIF
     C                   MOVE      *BLANKS       MeoufAr(i)
     C                   MOVEA     MEOUFDATA2    MeoufAr(i)
     C                   EVAL      i = i + 1
     C                   ENDDO
     C                   EVAL      i = 1
      *
      ** Update records in array to MEOUFMPD file
      *
     C                   DOW       (i <= h)
     C                   IF        MeoufAr(i) <> *BLANKS
     C                   MOVEL     MeoufAr(i)    OM50FS2
     C                   MOVE      *BLANKS       MEOUFDATA2
     C                   MOVEA     MeoufAr(i)    MEOUFDATA2
     C     KMEOUF7       CHAIN     MEOUFML7
     C                   IF        %FOUND(MEOUFML7)
     C                   EVAL      A_OM50FS = TOM50FS
     C                   EVAL      A_OM50F1 = TOM50F1
     C                   EVAL      A_OM50F2 = TOM50F2
     C                   EVAL      A_OM50F3 = TOM50F3
     C                   EVAL      A_OM50F4 = TOM50F4
     C                   Eval      A_OM50F5 = TOM50F5
     C                   UPDATE    @OUFMPDX0
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *BLANKS       MeoufAr(i)
     C                   EVAL      i = i + 1
     C                   ENDDO
      *
      ** Reset values
      *
     C                   EVAL      g = 0
     C                   EVAL      h = 0
     C                   EVAL      i = 0
     C                   EVAL      Main1 = *BLANKS
     C                   EVAL      Main2 = *BLANKS
     C                   EVAL      Main3 = *BLANKS
     C                   EVAL      NewRec = 'Y'
      *
      ** Process previous record
      *
     C                   EVAL      FirstRec = 'Y'
     C                   ELSE
     C                   IF        OMACTI = '*FORMAT'
     C                   EVAL      FirstRec = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Store data to temporary variables
      *
     C                   EVAL      OMNWRKS = OMNWRK
     C                   EVAL      OMMTPYS = OMMTPY
     C                   EVAL      OMMTAGS = OMMTAG
     C                   EVAL      OMSBRCS = OMSBRC
     C                   EVAL      OMCTRYS = OMCTRY
     C                   EVAL      OMCURRS = OMCURR
     C                   EVAL      OMNOSTS = OMNOST
     C                   EVAL      OMACTIS = OMACTI
     C                   EVAL      OM50FSS = OM50FS
     C                   EVAL      OM50F1S = OM50F1
     C                   EVAL      OM50F2S = OM50F2
     C                   EVAL      OM50F3S = OM50F3
     C                   EVAL      OM50F4S = OM50F4
     C                   EVAL      OM50F5S = OM50F5
     C                   ENDDO
      *
      ** Process end of report and audit report
      *
     C                   EXSR      SrRcfEnd
     C                   WRITE     HEADAU
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRcfEnd - Subroutine to write End of report.                *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRcfEnd      BEGSR
      *
      ** Check if printer file was used
      *
     C                   IF        Wopen1 = 'Y'
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN <= 2
     C                   WRITE     HEADPY1
     C                   ENDIF
     C                   WRITE     TRAILPY1
     C                   ENDIF
      *
     C                   IF        Wopen2 = 'Y'
     C                   EVAL      WDIFLN = OFLLN2 - PRTLN2
     C                   IF        WDIFLN <= 2
     C                   WRITE     HEADPY2
     C                   ENDIF
     C                   WRITE     TRAILPY2
     C                   ENDIF
      *
     C                   IF        Wopen3 = 'Y'
     C                   EVAL      WDIFLN = OFLLN3 - PRTLN3
     C                   IF        WDIFLN <= 2
     C                   WRITE     HEADPY3
     C                   ENDIF
     C                   WRITE     TRAILPY3
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey  = @OPTN
     C                   EVAL      DBase  = 001
     C                   EXSR      *Pssr
     C                   ENDIF
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
