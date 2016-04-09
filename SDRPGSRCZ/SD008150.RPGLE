     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Stamp Tax Effective Date update')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008150 - Stamp Tax Effective Date Update                   *
      *                                                               *
      *  Function: Run monthly, moves new values for all stamp tax    *
      *            defaults to current values and blanks out new      *
      *            values.                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. AR888911           Date 26Jan12               *
      *                 AR941869           Date 28Mar12               *
      *                 AR879983           Date 21Dec11               *
      *                 AR853091           Date 29Nov11               *
      *                 AR853257           Date 04Nov11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR888911 - In reversing a deal, REV column in Stamp Tax      *
      *             Movements Enquiry is not changing from N to Y     *
      *             (Recompile)                                       *
      *           - Applied for AR944923                              *
      *  AR941869 - Erroneous stamp tax on interest                   *
      *  AR879983 - Add stamp tax exchange rate (Recompile)           *
      *  AR853091 - Wrong default of Stamp Tax Rate on Principal      *
      *             in Stamp Tax Control Data Maintenance screen      *
      *  AR853257 - Account Keys for FT were not generated            *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  -  Error Processing                                   *
      *  INIT   -  Initialisation Processing                          *
      *  UPDICD -  Update Installation Control Data Subroutine        *
      *  UPDDBT -  Update Deafults by Business Type                   *
      *  END    -  Exit from Program                                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Stamp Tax Installation Control (Update)
 
     FSDSTPTL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Stamp Tax Defaults by Business (Update)
 
     FSDSTPDL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Stamp Tax History Detail (Update)
 
     FSDSTMDL0  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
     D RUNDATE         S              5S 0                                                  AR941869
 
     D/COPY ZSRSRC,ZALIGNZ1LE                                                               AR941869
      **  ZALIGN Subroutine Array                                                           AR941869
                                                                                            AR941869
     D/COPY ZSRSRC,ZDATE9Z1LE                                                               AR941869
      **  ZDATE9 Subroutine Array                                                           AR941869
                                                                                            AR941869
      ** Program Status Data Structure
 
     D/COPY ZACPYSRC,PSDS
 
      ** Standard D-specs
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** API Validation Error Array Declarations
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** API Validation X Error Array Declarations
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short Access Object Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     I/COPY ZSRSRC,ZDATE9Z2LE                                                               AR941869
      ** ZDATE9 Subroutine Array                                                            AR941869
                                                                                            AR941869
     I/COPY ZSRSRC,ZDAT10Z1LE                                                               AR941869
      ** ZDAT10 Subroutine Array                                                            AR941869
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise data
 
     C                   EXSR      INIT
 
      ** CONTROL RATE
      ** ------------
      ** Chain to SDSTPTPD for installation control data
 
     C                   MOVEL(P)  'CONTROL'     U#KEY            10
     C     U#KEY         CHAIN     SDSTPTL0                           80
 
     C                   If        *IN80  =  *OFF   AND
 
      ** And if New Effective Date is less than or equal to the rundate
 
     C**********                   A1EDTN <= BJRDNB AND                                     AR941869
     C**********                   A1EDTN >  0      OR                                      AR941869
     C**********                   A1EDTN >  BJRDNB AND                                     AR941869
     C**********                   A1EDTN <  BJDNWD                                         AR853091
     C**********                   A1EDTN <= BJDNWD                                AR853091 AR941869
     C                             A1EDTN <= RUNDATE AND                                    AR941869
     C                             A1EDTN >  0                                              AR941869
     C                   EXSR      UPDICD
     C                   ENDIF
 
      ** MODULE RATE
      ** -----------
 
     C     *LOVAL        SETLL     SDSTPDL0
     C                   READ      SDSTPDL0                               80
 
     C                   DOW       *IN80  =  *OFF
 
      ** Check if Rate Change is due today
 
     C**********         IF        A3EDTN <= BJRDNB AND                                     AR941869
     C**********                   A3EDTN >  0      OR                                      AR941869
     C**********                   A3EDTN >  BJRDNB AND                                     AR941869
     C**********                   A3EDTN <  BJDNWD                                         AR853091
     C**********                   A3EDTN <= BJDNWD                                AR853091 AR941869
     C                   IF        A3EDTN <= RUNDATE AND                                    AR941869
     C                             A3EDTN >  0                                              AR941869
     C                   EXSR      UPDDBT
     C                   ENDIF
 
      ** Read Next Record
 
     C                   READ      SDSTPDL0                               80
 
     C                   ENDDO
 
      ** Exit from program
 
     C                   EXSR      END
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Initial Processing                                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Define the LDA for error handling
      ** Call Access Program to obtain Banks details from PF/SDBANKPD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error.
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'SD008150'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            AR941869
      ** Convert Midas Day number of rundate to to day 01                                   AR941869
     C                   MOVE      BJRDNB        @@DAYN            5 0                      AR941869
     C                   EXSR      ZDATE9                                                   AR941869
     C                   MOVE      01            @@Z71D                                     AR941869
     C                   MOVE      @@VDT         ZZDTIN                                     AR941869
     C                   EXSR      ZDAT10                                                   AR941869
     C                   MOVE      ZZMDNO        RUNDATE                                    AR941869
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDICD - Update Installation Control Data Subroutine         *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     UPDICD        BEGSR
 
     C                   CLEAR                   @STMDV0
 
      ** Update but first write the record to the
      ** Historic Stamp Tax Details file.
 
     C                   MOVE      A1KEY         T2KEY
     C                   MOVE      A1STCY        T2SCCY
     C                   MOVE      A1STRT        T2TXRT
     C                   MOVE      A1EDTE        T2CDTE
     C                   MOVE      'R'           T2RCTP
     C                   MOVEL     A1SECC        T2SECC                                     AR853257
     C                   MOVE      A1SERT        T2SERT                                     AR853257
     C                   MOVE      BJRDNB        T2LCD
     C                   MOVE      'I'           T2TYLC
     C                   WRITE     @STMDV0
 
      ** Move New fields into Current fields
 
     C                   MOVE      A1STCN        A1STCY
     C                   MOVE      A1STRN        A1STRT
     C                   MOVE      A1SECN        A1SECC
     C                   MOVE      A1SERN        A1SERT
     C                   MOVE      A1EDTN        A1EDTE
 
      ** Move blanks into New fields
 
     C                   MOVE      *BLANKS       A1STCN
     C                   MOVE      *BLANKS       A1STRN
     C                   MOVE      *BLANKS       A1SECN
     C                   MOVE      *BLANKS       A1SERN
     C                   MOVE      *BLANKS       A1EDTN
 
      ** Set up type of last change and last change date
 
     C                   MOVE      BJRDNB        A1LCD
     C                   MOVE      'A'           A1TYLC
 
     C                   UPDATE    @STPTV0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDDBT - Update Deafults by Business Type                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     UPDDBT        BEGSR
 
     C                   CLEAR                   @STMDV0
 
      ** Update but first write the record to the
      ** Historic Stamp Tax Details file.
 
     C                   MOVE      A3KEY         T2KEY
     C                   MOVE      A3STCY        T2SCCY
 
     C                   IF        A3KEY = 'DEAL'
     C                   MOVEL     A3DTYP        T2TYPE
     C                   MOVE      A3DSTP        T2TYPE
     C                   MOVE      A3F01Y        T2F01Y                                     AR853257
     C                   MOVE      A3F05Y        T2F05Y                                     AR853257
     C                   MOVE      A3F99Y        T2F99Y                                     AR853257
     C                   ENDIF
 
     C                   IF        A3KEY = 'LOAN'
     C                   MOVEL     A3LTYP        T2TYPE
     C                   MOVE      A3LSTP        T2TYPE
     C                   MOVE      A3F01Y        T2F01Y                                     AR853257
     C                   MOVE      A3F05Y        T2F05Y                                     AR853257
     C                   MOVE      A3F99Y        T2F99Y                                     AR853257
     C                   ENDIF
 
     C                   IF        A3KEY = 'FACILITY'
     C                   MOVEL     A3FTYP        T2TYPE
     C                   MOVE      A3F01Y        T2F01Y                                     AR853257
     C                   MOVE      A3F05Y        T2F05Y                                     AR853257
     C                   MOVE      A3F99Y        T2F99Y                                     AR853257
     C                   ENDIF
 
     C                   IF        A3KEY = 'FEE'
     C                   MOVEL     A3LFTP        T2TYPE
     C                   ENDIF
 
     C                   IF        A3KEY = 'RETAIL'
     C                   MOVEL     A3ACCD        T2ACOD
     C                   MOVE      A3STCC        T2STCC                                     AR853257
     C                   ENDIF
 
      ** Move Rate
 
     C                   MOVE      A3STRT        T2TXRT
 
      ** If securities, set securities rate
 
     C                   IF        A3KEY = 'SECURITY' OR
     C                             A3KEY = 'POSSET'
     C                   MOVE      A3SERT        T2TXRT
     C                   ENDIF
 
      ** Set balance rate
 
     C                   MOVE      A3STRB        T2TXRB
 
     C                   MOVE      A3EDTE        T2CDTE
     C                   MOVE      'R'           T2RCTP
     C                   MOVE      BJRDNB        T2LCD
     C                   MOVE      'I'           T2TYLC
     C                   WRITE     @STMDV0
 
      ** Move New fields into Current fields
 
     C                   MOVE      A3STCN        A3STCY
     C                   MOVE      A3STBN        A3STRB
     C                   MOVE      A3STRN        A3STRT
     C                   MOVE      A3SECN        A3SECC
     C                   MOVE      A3SERN        A3SERT
     C                   MOVE      A3EDTN        A3EDTE
     C                   MOVE      A3NTCC        A3STCC
     C                   MOVE      A3N01Y        A3F01Y                                     AR853257
     C                   MOVE      A3N05Y        A3F05Y                                     AR853257
     C                   MOVE      A3N99Y        A3F99Y                                     AR853257
 
      ** Move blanks into New fields
 
     C                   MOVE      *BLANKS       A3STBN
     C                   MOVE      *BLANKS       A3STRN
     C                   MOVE      *BLANKS       A3STCN
     C                   MOVE      *BLANKS       A3SECN
     C                   MOVE      *BLANKS       A3SERN
     C                   MOVE      *BLANKS       A3EDTN
     C                   MOVE      *BLANKS       A3NTCC
     C                   MOVE      *BLANKS       A3N01Y                                     AR853257
     C                   MOVE      *BLANKS       A3N05Y                                     AR853257
     C                   MOVE      *BLANKS       A3N99Y                                     AR853257
 
      ** Set up type of last change and last change date
 
     C                   MOVE      BJRDNB        A3LCD
     C                   MOVE      'A'           A3TYLC
 
     C                   UPDATE    @STPDV0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END - Exit from Program                                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     END           BEGSR
     C                   EVAL      *INLR = *ON
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
     C/COPY ZSRSRC,ZALIGNZ2LE                                                               AR941869
     C/COPY ZSRSRC,ZEDITZ2LE                                                                AR941869
     C/COPY ZSRSRC,ZDATE9Z3LE                                                               AR941869
     C/COPY ZSRSRC,ZDAT10Z2LE                                                               AR941869
      *****************************************************************
      /EJECT
      *****************************************************************
**  @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                     AR941869
00366007310109601461                                                                        AR941869
**  @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                        AR941869
00000000310005900090001200015100181002120024300273003040033400365                           AR941869
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
