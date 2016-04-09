     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Module Initialization')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000118 - Midas SM Module Initialization                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR758718*CREATE    Date 04Oct10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR758718 - Bridge Enhancement                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDMMODPD  IF A E             DISK
      *  Midas SD Midas modules
     FMMODF     IF A E             DISK
      *  Midas SD - MIDAS Module flag file
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   Exsr      InsSDMMOD
     C                   Exsr      InsMMODF
     C                   Exsr      ExitPgm
      *****************************************************************
      *                                                               *
      * InsSDMMOD - Insert records to SDMMODPD                        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      *****************************************************************
      *
     C     InsSDMMOD     BegSr
     C                   Eval      BGMODS = 'MMOD'
     C                   Eval      BGLCD  = 0
     C                   Eval      BGTYLC = 'A'
     C                   Eval      BGMTMI = 'N'
     C                   Eval      BGSWFT = 'N'
     C                   Eval      BGSWST = 'N'
     C                   Eval      BGSWCL = 'N'
     C                   Eval      BGSWSL = 'N'
     C                   Eval      BGSWSM = 'N'
     C                   Eval      BGSWDL = 'N'
     C                   Eval      BGSDGL = 'Y'
     C                   Eval      BGDLFX = 'N'
     C                   Eval      BGSYLN = 'N'
     C                   Eval      BGEXMG = 'N'
     C                   Eval      BGFNMO = 'N'
     C                   Eval      BGSTRT = 'N'
     C                   Eval      BGCSLN = 'N'
     C                   Eval      BGRTBN = 'N'
     C                   Eval      BGMSDL = 'N'
     C                   Eval      BGSECS = 'N'
     C                   Eval      BGAURC = 'N'
     C                   Eval      BGBDLI = 'N'
     C                   Eval      BGDRSD = 'N'
     C                   Eval      BGDRCM = 'N'
     C                   Eval      BGDRFE = 'N'
     C                   Eval      BGDRMM = 'N'
     C                   Eval      BGDRAR = 'N'
     C                   Eval      BGFDTR = 'N'
     C                   Eval      BGDRCA = 'N'
     C                   Eval      BGFUOP = 'N'
     C                   Eval      BGMTSL = 'N'
     C                   Eval      BGMTDL = 'N'
     C                   Eval      BGMTGL = 'N'
     C                   Eval      BGMTCL = 'N'
     C                   Eval      BGNWMI = 'N'
     C                   Eval      BGFIIN = 'N'
     C                   Eval      BGDLMM = 'N'
     C                   Eval      BGINCN = 'N'
     C                   Eval      BGTRMG = 'N'
     C                   Eval      BGRKMG = 'N'
     C                   Eval      BGTSKY = 'N'
     C                   Eval      BGMIDQ = 'N'
     C                   Eval      BGMFIC = 'N'
     C                   Eval      BGIOAC = 'N'
     C                   Eval      BGWDPR = 'N'
     C                   Eval      BGSARP = 'N'
     C                   Eval      BGFRIN = 'N'
     C                   Eval      BGLRIN = 'N'
     C                   Eval      BGDRIN = 'N'
     C                   Eval      BGGRIN = 'N'
     C                   Eval      BGBRIN = 'N'
     C                   Eval      BGIRIN = 'N'
     C                   Eval      BGSWEI = 'N'
     C                   Eval      BGPFMG = 'N'
     C                   Eval      BGCRMG = 'N'
     C                   Eval      BGHORP = 'N'
     C                   Eval      BGAVBL = 'N'
     C                   Eval      BGMARG = 'N'
     C                   Eval      BGCFMT = 'N'
     C                   Eval      BGMIMX = 'N'
     C                   Eval      BGRCFI = 'Y'
     C                   Eval      BGAMIN = 'N'
     C                   Eval      BGSWRT = 'N'
     C                   Eval      BGFLND = 'N'
     C                   Eval      BGLMCR = 'N'
     C                   Eval      BGCNTX = 'N'
     C                   Eval      BGSTDU = 'N'
     C                   Eval      BGUDRS = 'N'
     C                   Eval      BGCHDL = 'N'
     C                   Eval      BGCHLN = 'N'
     C                   Eval      BGCHOB = 'N'
     C                   Eval      BGCHIP = 'N'
     C                   Eval      BGCHDI = 'N'
     C                   Eval      BGOPDK = 'N'
     C                   Eval      BGMBIN = 'Y'
     C                   Eval      BGNNST = 'N'
     C                   Eval      BGNOST = 'N'
     C                   Eval      BGNPST = 'N'
     C                   Eval      BGNQST = 'N'
     C                   Eval      BGNRST = 'N'
     C                   Eval      BGNSST = 'N'
     C                   Eval      BGNTST = 'N'
     C                   Eval      BGNUST = 'N'
     C                   Eval      BGNVST = 'N'
     C                   Eval      BGNWST = 'N'
     C                   Eval      BGNXST = 'N'
     C                   Eval      BGNYST = 'N'
     C                   Eval      BGNZST = 'N'
     C                   Eval      BGN0ST = 'N'
     C                   Eval      BGN1ST = 'N'
     C                   Eval      BGN2ST = 'N'
     C                   Eval      BGN3ST = 'N'
     C                   Eval      BGN4ST = 'N'
     C                   Eval      BGN5ST = 'N'
     C                   Eval      BGN6ST = 'N'
     C                   Eval      BGN7ST = 'N'
     C                   Eval      BGN8ST = 'N'
     C                   Eval      BGN9ST = 'N'
     C                   Eval      BGOAST = 'N'
     C                   Eval      BGOBST = 'N'
     C                   Eval      BGOCST = 'N'
     C                   Eval      BGODST = 'N'
     C                   Eval      BGOEST = 'N'
     C                   Eval      BGOFST = 'N'
     C                   Eval      BGOGST = 'N'
     C                   Eval      BGOHST = 'N'
     C                   Eval      BGOIST = 'N'
     C                   Eval      BGOJST = 'N'
     C                   Eval      BGOKST = 'N'
     C                   Eval      BGOLST = 'N'
     C                   Eval      BGOMST = 'N'
     C                   Eval      BGONST = 'N'
     C                   Eval      BGOOST = 'N'
     C                   Eval      BGOPST = 'N'
     C                   Eval      BGOQST = 'N'
     C                   Eval      BGORST = 'N'
     C                   Eval      BGOSST = 'N'
     C                   Write     SDMMODD0
     C                   EndSr
      *****************************************************************
      *                                                               *
      * InsMMODF  - Insert records to MMODF                           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      *****************************************************************
      *
      *
     C     InsMMODF      BegSr
     C                   Eval      SDGL  = 'Y'
     C                   Eval      DLFL  = 'N'
     C                   Eval      RTFL  = 'N'
     C                   Eval      CLFL  = 'N'
     C                   Eval      STFL  = 'N'
     C                   Eval      BCFL  = 'N'
     C                   Eval      EMFL  = 'N'
     C                   Eval      FMFL  = 'N'
     C                   Eval      SRFL  = 'N'
     C                   Eval      LEFL  = 'N'
     C                   Eval      FDFL  = 'N'
     C                   Eval      CMFL  = 'N'
     C                   Eval      FXFL  = 'N'
     C                   Eval      MMFL  = 'N'
     C                   Eval      CNFL  = 'N'
     C                   Eval      RETF  = 'N'
     C                   Eval      ZZ001 = 'N'
     C                   Eval      MSWF  = 'N'
     C                   Eval      ABFL  = 'N'
     C                   Eval      CAFL  = 'N'
     C                   Eval      SEFL  = 'N'
     C                   Eval      RCFL  = 'N'
     C                   Eval      IAFL  = 'N'
     C                   Eval      ZZ001A= 'N'
     C                   Eval      SWDE  = 'N'
     C                   Eval      SWSM  = 'N'
     C                   Eval      SWCO  = 'N'
     C                   Eval      SWLN  = 'N'
     C                   Eval      SWLC  = 'N'
     C                   Eval      SWTR  = 'N'
     C                   Eval      SWMO  = 'N'
     C                   Eval      SWCN  = 'N'
     C                   Eval      TLDE  = 'N'
     C                   Eval      TLSM  = 'N'
     C                   Eval      TLCO  = 'N'
     C                   Eval      TLLN  = 'N'
     C                   Eval      TLLC  = 'N'
     C                   Eval      TLTR  = 'N'
     C                   Eval      TLTX  = 'N'
     C                   Eval      TLAR  = 'N'
     C                   Eval      MCDL  = 'N'
     C                   Eval      ZZ001B= 'N'
     C                   Eval      MCLE  = 'N'
     C                   Eval      MCOB  = 'N'
     C                   Eval      CH    = 'N'
     C                   Eval      ZZ002 = 'NN'
     C                   Eval      FDRT  = 'N'
     C                   Eval      GRFL  = 'N'
     C                   Eval      FFFL  = 'N'
     C                   Eval      MTFL  = 'N'
     C                   Eval      MTCO  = 'N'
     C                   Eval      MTDE  = 'N'
     C                   Eval      MTGE  = 'N'
     C                   Eval      MTLN  = 'N'
     C                   Eval      NMFL  = 'N'
     C                   Eval      FTFL  = 'N'
     C                   Eval      TKFL  = 'N'
     C                   Eval      ZZ001C= 'N'
     C                   Eval      CFFL  = 'N'
     C                   Eval      ZZ002C= 'NN'
     C                   Eval      RMFL  = 'N'
     C                   Eval      ZZ002A= 'NN'
     C                   Eval      WNFL  = 'N'
     C                   Eval      ZZ007 = 'NNNNNNN'
     C                   Eval      MSEI  = 'N'
     C                   Eval      ZZ182 = *All'N'
     C                   Write     MMODFF
     C                   EndSr
      *
     C     ExitPgm       BegSr
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndSr
